import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/navigation_bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';
import 'package:fixbee_partner/ui/custom_widget/job_notification.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'custom_profile.dart';
import 'history_screen.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NavigationScreen extends StatefulWidget {
  final bool gotJob;

  const NavigationScreen({Key key, this.gotJob = false}) : super(key: key);
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

List<Widget> pages = [
  Home(),
  HistoryScreen(),
  WalletScreen(),
  CustomProfile(),
];

class _NavigationScreenState extends State<NavigationScreen> {
  PageController _pageController;
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






  @override
  void initState() {
    _pageController = PageController();
    _bloc = NavigationBloc(NavigationModel());
    _setupFCM();

    _visible = widget.gotJob;
    super.initState();

    Future.delayed(const Duration(seconds: 150), () {
      if (this.mounted) {
        setState(() {
          _visible = false;
        });
      }
    });
  }

  void _setupFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_MESSAGE');
        _getJobDetails(message);
//        _startTimer();
      },
      onResume: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_RESUME');
        _getJobDetails(message);
        //_startTimer();
      },
      onLaunch: (message) async {
        log(message.toString(), name: 'ON_LAUNCH');
        _getJobDetails(message);
        //_startTimer();
      },
    );
  }

  void _getJobDetails(Map<String, dynamic> message) {
    setState(() {
      _visible = true;
    });
    if (message.containsKey('data')) {
      Map data = message['data'];
      if (data.containsKey('order_id')) {
        orderId = data['order_id'];
      }
      if (data.containsKey('service_id')) {
        serviceId = data['service_id'];
        print(serviceId + "serviceId");
        _bloc.fire(NavigationEvent.getServiceData, message: {"id": serviceId});
      }
      if (data.containsKey('user_id')) {
        userId = data['user_id'];
      }
      if (data.containsKey('name')) {
        userName = data['name'];
      }

      if (data.containsKey('place_id')) {
        placeId = data['place_id'];
      }
      if (data.containsKey('billing_address')) {
        billingAddress = data['billing_address'];
      }
      if (data.containsKey('quantity_info')) {
        quantityInfo = data['quantity_info'];
      }
      if (data.containsKey('slotted')) {
        slotted = data['slotted'];
        if (slotted.toString() == 'true') {
          slot = data['slot'];
        }
      }
      if (data.containsKey('phone_number')) {
        phoneNumber = data['phone_number'];
        print(phoneNumber + "pppp");
      }
      if (data.containsKey('payment_mode')) {
        paymentMode = data['payment_mode'];
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: pages[_currentIndex]),
              _visible
                  ? Visibility(
                      visible: _visible,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: JobNotification(
                        orderId: orderId,
                        serviceName: viewModel.service.serviceName,
                        quantity: quantityInfo,
                        userName: userName,
                        paymentMode:
                            (paymentMode == 'false') ? "Online Payment" : "COD",
                        addressLine: billingAddress,
                        userNumber: phoneNumber,
                        slotted: slotted,
                        slot: slot,
                        onConfirm: () {
                          _bloc.fire(NavigationEvent.onConfirmJob,
                              message: {"orderId": orderId, "Accept": true},
                              onHandled: (e, m) {
                            if (!m.order.slotted) {
                              Route route = MaterialPageRoute(
                                  builder: (context) => WorkScreen(
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
                                      ));
                              Navigator.pushReplacement(context, route);
                            } else {
                              setState(() {
                                _visible = false;
                              });
                            }
                          });
                        },
                        onDecline: () {
                          _showCancelBox();
                        },
                      ),
                    )
                  : SizedBox()
            ],
          );
        }),
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
