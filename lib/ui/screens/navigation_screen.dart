import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/navigation_bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';
import 'package:fixbee_partner/ui/custom_widget/new_service_notification.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vibration/vibration.dart';
import 'custom_profile.dart';
import 'history_screen.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:background_location/background_location.dart';

class NavigationScreen extends StatefulWidget {
  final bool gotJob;
  const NavigationScreen({Key key, this.gotJob = false}) : super(key: key);
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> pages;
  PageController _pageController;
  static GoogleMapController mapController;
  bool check = false;
  bool _visible;
  NavigationBloc _bloc;
  int _currentIndex = 0;
  String orderId,
      userId,
      serviceId,
      placeId,
      quantityInfo,
      userName,
      billingAddress,
      phoneNumber,
      slot,
      slotted,
      paymentMode;
  int _lastNotification = 0;

  @override
  void initState() {
    pages = [
      Home(
        onSwitchChangedState: (active) {
          print('SWITCH');
          if (active) {
            _bloc.startTimer();
          } else {
            _bloc.pauseTimer();
          }
        },
      ),
      HistoryScreen(),
      WalletScreen(),
      CustomProfile(),
    ];

    _pageController = PageController();
    _bloc = NavigationBloc(NavigationModel());
    _setupFCM();
    _visible = widget.gotJob;
    super.initState();
  }

  void _setupFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_MESSAGE');
        if ((DateTime.now().microsecondsSinceEpoch - _lastNotification) >
            1000000) {
          _lastNotification = DateTime.now().microsecondsSinceEpoch;
          _getJobDetails(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_RESUME');

        _getJobDetails(message);
      },
      onLaunch: (message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_LAUNCH');

        _getJobDetails(message);
      },
    );
  }

  _getJobDetails(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      Map data = message['data'];
      orderId = data['id'];
      userName = data['name'];
      Map address = json.decode(data['address']);
      billingAddress = address['Address']['Line1'];
      paymentMode = data['mode'];
    }
    _showNotificationDialog();
  }

  bool isLoading = false;
  bool onChanged() {
    setState(() {
      isLoading = _bloc.latestViewModel.onJobConfirmed;
    });
    return isLoading;
  }

  _showNotificationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Vibration.vibrate(duration: 1000);
          Future.delayed(const Duration(seconds: 150), () async {
            Navigator.pop(context);
          });
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(10),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return NewServiceNotification(
                orderId: orderId.toString().toUpperCase(),
                userName: userName.toString().toUpperCase(),
                address: billingAddress,
                paymentMode: paymentMode,
                loading: onChanged(),
                onConfirm: () {
                  _bloc.fire(NavigationEvent.onConfirmJob,
                      message: {"orderId": orderId, "Accept": true},
                      onFired: (e, m) {
                    onChanged();
                  }, onHandled: (e, m) {
                    Navigator.pop(context);

                    Route route = MaterialPageRoute(
                        builder: (context) => WorkScreen(
                              orderBasePrice: m.order.orderBasePrice,
                              orderTaxCharge: m.order.orderTaxCharge,
                              orderServiceCharge: m.order.orderServiceCharge,
                              orderAmount: m.order.orderAmount,
                              quantity: m.order.quantity,
                              userId: m.user.userId,
                              activeOrderStatus: m.order.status,
                              orderId: m.order.orderId,
                              googlePlaceId: m.location.googlePlaceId,
                              phoneNumber: m.user.phoneNumber,
                              userName: m.user.firstname +
                                  " " +
                                  m.user.middlename +
                                  " " +
                                  m.user.lastname,
                              userProfilePicUrl: m.user.profilePicUrl,
                              addressLine: m.location.addressLine,
                              landmark: m.location.landmark,
                              serviceName: m.service.serviceName,
                              timeStamp: m.order.timeStamp,
                              amount: m.order.price,
                              userProfilePicId: m.user.profilePicId,
                              cashOnDelivery: m.order.cashOnDelivery,
                              basePrice: m.order.basePrice,
                              taxPercent: m.order.taxPercent,
                              serviceCharge: m.order.serviceCharge,
                            ));
                    Navigator.pushReplacement(context, route);
                  });
                },
                onDecline: () {
                  _showCancelBox();
                },
              );
            }),
          );
        },
        barrierDismissible: false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bloc.endTimer();
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavBar(
          onPageSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: SafeArea(
          child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
            return Stack(
              children: [
                pages[_currentIndex],
              ],
            );
          }),
        ),
      ),
    );
  }

  _showCancelBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Are you sure about declining?"),
            actions: [
              FlatButton(
                onPressed: () {
                  setState(() {
                    _visible = false;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
            ],
          );
        });
  }
}
