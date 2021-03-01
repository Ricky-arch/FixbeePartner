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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:vibration/vibration.dart';
import '../../Constants.dart';
import 'custom_profile.dart';
import 'history_screen.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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
      paymentMode,
      redirect,
      address;
  int _lastNotification = 0;

  Box<String> _BEENAME;
  _openHive() async {
    _BEENAME = Hive.box<String>("BEE");
  }

  @override
  void initState() {
    _openHive();
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
    if (_BEENAME.get("myActiveStatus") == "true") _bloc.startTimer();

    _setupFCM();

    _visible = widget.gotJob;
    // _bloc.fire(NavigationEvent.updateFcmTest);
    super.initState();
  }

  void _setupFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_MESSAGE');
        print('reached');
        if ((DateTime.now().microsecondsSinceEpoch - _lastNotification) >
            1000000) {
          _lastNotification = DateTime.now().microsecondsSinceEpoch;
          print('reached1');
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
      redirect = data['redirect'];
      orderId = data['id'];
      userName = data['name'];
      address = data['address'];
      paymentMode = data['mode'];
    }
    log(address, name: 'User Address');

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
          // Future.delayed(const Duration(seconds: 90), () async {
          //   Navigator.pop(context);
          // });
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              insetPadding: EdgeInsets.all(10),
              child: NewServiceNotification(
                orderId: orderId.toString().toUpperCase(),
                userName: userName.toString().toUpperCase(),
                address: address,
                paymentMode: paymentMode,
                onConfirm: () {
                  _bloc.fire(NavigationEvent.onConfirmJob,
                      message: {"orderId": orderId, "Accept": true},
                      onFired: (e, m) {
                    onChanged();
                  }, onHandled: (e, m) {
                    if (m.orderExpired) {
                      Navigator.pop(context);
                      _showOrderExpiredDialog(
                          "Order request invalid or expired");
                    } else {
                      Route route = MaterialPageRoute(
                          builder: (context) => WorkScreen(
                                orderModel: m.ordersModel,
                              ));
                      Navigator.pushReplacement(context, route);
                    }
                  });
                },
                onDecline: () {
                  _showCancelBox();
                },
              ));
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
    return Scaffold(
      floatingActionButton: (_currentIndex == 0)
          ? Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 30),
                      child: FloatingActionButton(
                        mini: false,
                        elevation: 0,
                        backgroundColor: Colors.amber,
                        child: Icon(
                          Icons.add_alert,
                          color: PrimaryColors.backgroundColor,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Positioned(
                        top: 1.0,
                        right: 2.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Center(
                              child: Text(
                                '1',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            )
          : SizedBox(),
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

  _showOrderExpiredDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message,
              maxLines: null,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              )
            ],
          );
        });
  }
}
