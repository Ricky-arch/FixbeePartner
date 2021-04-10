import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/navigation_bloc.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';
import 'package:fixbee_partner/ui/custom_widget/order_widget.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants.dart';
import '../../data_store.dart';
import 'custom_profile.dart';
import 'history_screen.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NavigationScreen extends StatefulWidget {
  final bool gotJob;
  final int currentAppBuildNumber;
  const NavigationScreen(
      {Key key, this.gotJob = false, this.currentAppBuildNumber})
      : super(key: key);
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
    Future.delayed(Duration(seconds: 3), () {
      if (widget.currentAppBuildNumber != null) if (widget
              .currentAppBuildNumber <
          DataStore.metaData.buildNumber) _showUpdateDialog();
    });
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
    return true;
  }

  _getJobDetails(Map<String, dynamic> message) {


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
          ..serviceName = data['service']
          ..userName = userName
          ..cashOnDelivery = paymentMode == 'cod' ? true : false;

        setState(() {
          _onNotificationOrderList.add(_orderNotificationModel);
        });
      } else {
        Map notification = message['notification'];
        if (notification['body'] != null && redirect == 'JOB_UPDATE')
          _showMessageDialog(notification['body']);
        if (notification['body'] != null && redirect == 'JOB_CANCEL')
          _showCancelDialog(notification['body']);
      }
    }
  }

  _showMessageDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: Theme.of(context).canvasColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          );
        });
  }

  _orderSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Theme.of(context).canvasColor,
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
                              color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
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
                                    // orderIdReceivedFromNotification.clear();
                                  });
                                  Navigator.pop(context);
                                  Orders order =
                                      await _bloc.onConfirmDeclineJob(value);
                                  if (order == null) {
                                    _showOrderExpiredDialog(
                                        "Order request invalid or expired");
                                  } else {
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
      floatingActionButton: (_currentIndex != 3 && _currentIndex != 1)
          ? Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _orderSheet();
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 30),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Theme.of(context).hintColor,
                              shape: BoxShape.circle),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor),
                            child: Icon(
                              Icons.notification_important,
                              size: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 8,
                          top: -3,
                          child: Container(
                            decoration: BoxDecoration(
                                color: PrimaryColors.whiteColor,
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: Text(
                                  _onNotificationOrderList.length.toString(),
                                  style: TextStyle(
                                      color: PrimaryColors.backgroundColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
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
          child: Stack(
        children: [
          pages[_currentIndex],
        ],
      )),
    );
  }

  _showOrderExpiredDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            content: Text(
              message,
              maxLines: null,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Theme.of(context).canvasColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  ),
                ),
              )
            ],
          );
        });
  }

  _showUpdateDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: PrimaryColors.backgroundColor,
            content: Text(
              'Update Available!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              RaisedButton(
                elevation: 4,
                color: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                onPressed: () {
                  _launchURL(Constants.PLAYSTORE_APP_LINK);
                },
                child: Text('Update'),
              ),
              RaisedButton(
                elevation: 4,
                color: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Skip'),
              )
            ],
          );
        });
  }

  _showCancelDialog(message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: Theme.of(context).canvasColor,
            content: Text(
              'Order has been cancelled!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).errorColor),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Theme.of(context).canvasColor,
                child: Text('OK'),
                textColor: Theme.of(context).primaryColor,
              )
            ],
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
