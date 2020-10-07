import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/navigation_bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/active_order_remainder.dart';
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';

import 'package:fixbee_partner/ui/custom_widget/new_service_notification.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

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
    _bloc.fire(NavigationEvent.checkActiveService);
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
        _getJobDetails(message);
      },
      onResume: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_RESUME');

        _getJobDetails(message);
      },
      onLaunch: (message) async {
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
            child: NewServiceNotification(
              orderId: orderId.toString().toUpperCase(),
              userName: userName.toString().toUpperCase(),
              address: billingAddress,
              paymentMode: paymentMode,
              onConfirm: () {

                _bloc.fire(NavigationEvent.onConfirmJob,
                    message: {"orderId": orderId, "Accept": true},
                    onHandled: (e, m) {
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
            ),
          );
        },
        barrierDismissible: false);
  }

  @override
  void dispose() {
    _pageController.dispose();
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
                (viewModel.isOrderActive)
                    ? Positioned(
                        top: MediaQuery.of(context).size.height - 150,
                        left: (MediaQuery.of(context).size.width / 2) - 100,
                        child: ActiveOrderRemainder(
                          workScreen: () {

                            _bloc.fire(NavigationEvent.getActiveOrder, onHandled: (e,m){
                              print(m.order.price.toString()+"STATUS");
                              Route route = MaterialPageRoute(
                                  builder: (context) => WorkScreen(
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
                        ))
                    : SizedBox(),
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
