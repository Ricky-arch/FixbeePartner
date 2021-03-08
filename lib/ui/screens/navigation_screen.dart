import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/navigation_bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';
import 'package:fixbee_partner/ui/custom_widget/new_service_notification.dart';
import 'package:fixbee_partner/ui/custom_widget/order_notifcation.dart';
import 'package:fixbee_partner/ui/custom_widget/order_widget.dart';
import 'package:fixbee_partner/ui/custom_widget/profile_notification.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

String fcmTest = '';

class _NavigationScreenState extends State<NavigationScreen> {
  List<OrderNotificationModel> _onNotificationOrderList = [];
  List<Widget> pages;
  List<String> orderIdReceivedFromNotification = [];
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
  OrderNotificationModel _orderNotificationModel = OrderNotificationModel();

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
          print('FCM_RESUME:  ' + fcmTest);
          _getJobDetails(message);
        },
        onLaunch: (message) async {
          FlutterRingtonePlayer.playNotification();
          log(message.toString(), name: 'ON_LAUNCH');
          print('FCM_LAUNCH:  ' + fcmTest);
          _getJobDetails(message);
        },
        onBackgroundMessage: myBackgroundMessageHandler);
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    //print('FCM_BACKGROUND_MESSAGE  :  ' + message.toString());
    return true;
  }

  _getJobDetails(Map<String, dynamic> message) {
    //print(message);
    if (message.containsKey('data')) {
      Map data = message['data'];

      redirect = data['redirect'];
      if (redirect == 'JOB_REQUEST') {
        orderId = data['id'];
        userName = data['name'];
        address = data['address'];
        paymentMode = data['mode'];
        _orderNotificationModel
          ..orderId = orderId
          ..orderAddress = address
          ..serviceName = 'Tell Sagnik'
          ..userName = userName
          ..cashOnDelivery = paymentMode == 'COD' ? true : false;

        if (!orderIdReceivedFromNotification.contains(orderId)) {
          setState(() {
            orderIdReceivedFromNotification.add(orderId);
            _onNotificationOrderList.add(_orderNotificationModel);
          });
        }
      }
    }

    // _showNotificationDialog();
  }

  _orderSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: PrimaryColors.backgroundColor,
        context: context,
        builder: (builder) {
          return Container(
            child: SingleChildScrollView(
              child: (_onNotificationOrderList == null ||
                      _onNotificationOrderList.length == 0)
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 8.0),
                      child: Center(
                        child: Text(
                          "NO WORRIES YOU WILL SOON RECEIVE  ORDER!",
                          style: TextStyle(
                              color: PrimaryColors.yellowColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // margin: const EdgeInsets.all(12.0),
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "YOUR ORDERS",
                            style: TextStyle(
                                color: PrimaryColors.yellowColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _onNotificationOrderList.length,
                            itemBuilder: (ctx, index) {
                              return OrderWidget(
                                orderId:
                                    _onNotificationOrderList[index].orderId,
                                index: index,
                                userName:
                                    _onNotificationOrderList[index].userName,
                                serviceName:
                                    _onNotificationOrderList[index].serviceName,
                                confirm: (value) async {
                                  setState(() {
                                    _onNotificationOrderList.clear();
                                    orderIdReceivedFromNotification.clear();
                                  });
                                  Navigator.pop(context);
                                  Orders order= await _bloc.onConfirmDeclineJob(value);
                                  if(order==null){
                                    // Navigator.pop(context);
                                    _showOrderExpiredDialog(
                                        "Order request invalid or expired");
                                  }
                                  else{
                                    // Navigator.pop(context);
                                    Route route = MaterialPageRoute(
                                        builder: (context) => WorkScreen(
                                          orderModel: order,
                                        ));
                                    Navigator.push(context, route);
                                  }
                                },
                                decline: (value) async {
                                  setState(() {
                                    _onNotificationOrderList.removeAt(value);
                                    orderIdReceivedFromNotification.removeAt(value);
                                    if(_onNotificationOrderList.length==0)
                                      orderIdReceivedFromNotification.clear();
                                  });


                                  //Navigator.pop(context);
                                },
                                orderAddress: _onNotificationOrderList[index]
                                    .orderAddress,
                                orderMode: _onNotificationOrderList[index]
                                        .cashOnDelivery
                                    ? 'COD'
                                    : 'ONLINE',
                              );
                            }),
                      ],
                    ),
            ),
          );
        });
  }

  _profileSheet() {
    showModalBottomSheet(
        backgroundColor: PrimaryColors.backgroundColor,
        context: context,
        builder: (builder) {
          return ProfileNotification();
        });
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
      floatingActionButton: (_currentIndex == 0 && _currentIndex != 3)
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
                        onPressed: () {
                          _orderSheet();
                        },
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
                                _onNotificationOrderList.length.toString(),
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
          : (_currentIndex == 3)
              ? FloatingActionButton(
                  mini: false,
                  elevation: 0,
                  backgroundColor: Colors.amber,
                  child: Icon(
                    Icons.add_alert,
                    color: PrimaryColors.backgroundColor,
                    size: 25,
                  ),
                  onPressed: () {
                    _profileSheet();
                  },
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
          child: Stack(
        children: [
          pages[_currentIndex],
        ],
      )),
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
