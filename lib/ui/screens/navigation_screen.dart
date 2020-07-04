import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/navigation_bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/job_model.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';
import 'package:fixbee_partner/ui/custom_widget/job_notification.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/profile_new.dart';
import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'history.dart';

class NavigationScreen extends StatefulWidget {
  final bool jobDeclined;
  final bool gotJob;

  const NavigationScreen(
      {Key key, this.jobDeclined = false, this.gotJob = false})
      : super(key: key);
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

List<Widget> pages = [
  const Home(),
  const HistoryScreen(),
  const WalletScreen(),
  ProfileNew(),
];

class _NavigationScreenState extends State<NavigationScreen> {
  JobModel _jobModel;
  NavigationBloc _bloc;
  int _currentIndex = 0;
  bool _jobDeclined;
  bool _gotJob;
  Timer _timer;
  int _start = 150;

  @override
  void initState() {
    _jobModel = JobModel();
    _bloc = NavigationBloc(NavigationModel());
    _setupFCM();
    _jobDeclined = widget.jobDeclined;
    _gotJob = widget.gotJob;
    super.initState();
  }

  void _setupFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_MESSAGE');
        _getJobDetails(message);
        _startTimer();
      },
      onResume: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_RESUME');
        _getJobDetails(message);
        _startTimer();
      },
      onLaunch: (message) async {
        log(message.toString(), name: 'ON_LAUNCH');
        _getJobDetails(message);
        _startTimer();
      },
    );
  }

  void _getJobDetails(Map<String, dynamic> message) {
    String orderID;
    if (message.containsKey('data')) {
      Map data = message['data'];
      if (data.containsKey('id')) {
        orderID = data['id'];
      }
    }
    if (orderID != null)
      _bloc.fire(
        NavigationEvent.onMessage,
        message: {'order_id': orderID},
        onHandled: (e, m) {
          _gotJob = m.gotJob;
          _jobModel.graphQLId = m.order.graphQLId;
          _jobModel.locationId = m.location.locationId;
          _jobModel.locationName = m.location.locationName;
          _jobModel.addressLine = m.location.addressLine;
          _jobModel.googlePlaceId = m.location.googlePlaceId;
          _jobModel.serviceId = m.service.serviceId;
          _jobModel.serviceName = m.service.serviceName;
          _jobModel.priceable = m.service.priceable;
          _jobModel.basePrice = m.service.basePrice;
          _jobModel.serviceCharge = m.service.serviceCharge;
          _jobModel.taxPercent = m.service.taxPercent;
          _jobModel.userId = m.user.userId;
          _jobModel.userFirstname = m.user.firstname;
          _jobModel.userMiddlename = m.user.middlename;
          _jobModel.userLastname = m.user.lastname;
          _jobModel.userPhoneNumber = m.user.phoneNumber;
          _jobModel.cashOnDelivery = m.order.cashOnDelivery;
          _jobModel.orderId = m.order.orderId;
          _jobModel.userProfilePicUrl = m.user.profilePicUrl;
          _jobModel.quantity = m.order.quantity;
        },
      );
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            setState(() {
              _jobDeclined = true;
            });
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
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
              (!_jobDeclined && _gotJob)
                  ? JobNotification(
                      userName: _jobModel.userFirstname +
                          " " +
                          _jobModel.userMiddlename +
                          " " +
                          _jobModel.userLastname,
                      paymentMode:
                          _jobModel.cashOnDelivery ? "COD" : "Online Payment",
                      profilePicUrl: _jobModel.userProfilePicUrl,
                      addressLine: _jobModel.addressLine,
                      userNumber: _jobModel.userPhoneNumber,
                      onConfirm: () {
                        _bloc.fire(NavigationEvent.onConfirmDeclineJob,
                            message: {
                              "orderId": _jobModel.orderId,
                              "Accept": "true"
                            });
                        if (!_jobModel.slotted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkScreen()));
                        } else {
                          setState(() {
                            _gotJob = false;
                          });
                        }
                      },
                      onDecline: () {
                        setState(() {
                          _jobDeclined = false;
                        });
                      },
                    )
                  : SizedBox(),
            ],
          );
        }),
      ),
    );
  }
}
