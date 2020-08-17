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
        //_startTimer();
      },
      onLaunch: (message) async {
        log(message.toString(), name: 'ON_LAUNCH');
        _getJobDetails(message);
        //_startTimer();
      },
    );
  }

  _getJobDetails(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      Map data = message['data'];
      orderId = data['id'];
      userName = data['name'];
      Map address=json.decode(data['address']);
      billingAddress = address['Address']['Line1'];
      paymentMode = data['mode'];
    }
    _showNotificationDialog();
  }
  _showNotificationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 150), () async {
            Navigator.pop(context);
          });
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(10),
            child: NewServiceNotification(
              orderId: orderId,
              userName: userName,
              address: billingAddress,
              paymentMode: paymentMode,
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
                              casOnDelivery: m.order.cashOnDelivery,
                            ));
                    Navigator.pushReplacement(context, route);
                  }
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
            ],
          );
        }),
      ),
    );
  }

  _showCancelModalSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                Container(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Do you really want to cancel the order?"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _visible = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Yes"),
                        ),
                        RaisedButton(
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No"),
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          );
        });
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
