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

  NavigationBloc _bloc;
  int _currentIndex = 0;
  bool _jobDeclined;
  bool _gotJob;
  Timer _timer;
  int _start = 150;


  @override
  void initState() {
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
                      userName: viewModel.user.firstname +
                          " " +
                          viewModel.user.middlename +
                          " " +
                          viewModel.user.lastname,
                      paymentMode:
                          viewModel.order.cashOnDelivery ? "COD" : "Online Payment",
                      profilePicUrl: viewModel.user.profilePicUrl,
                      addressLine: viewModel.location.addressLine,
                      userNumber: viewModel.user.phoneNumber,
                      onConfirm: () {
                        _bloc.fire(NavigationEvent.onConfirmDeclineJob,
                            message: {
                              "orderId": viewModel.order.orderId,
                              "Accept": "true"
                            });
                        if (!viewModel.order.slotted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkScreen(
                                    userFirstname: viewModel.user.firstname,
                                    userMiddlename: viewModel.user.middlename,
                                    userLastname: viewModel.user.lastname,
                                    userId: viewModel.user.userId,
                                    userProfilePicUrl: viewModel.user.profilePicUrl,
                                    userPhoneNumber: viewModel.user.phoneNumber,
                                    serviceName: viewModel.service.serviceName,
                                    serviceId: viewModel.service.serviceId,
                                    cashOnDelivery: viewModel.order.cashOnDelivery,
                                    orderId: viewModel.order.orderId,
                                    otp: viewModel.order.otp,
                                    googlePlaceId: viewModel.location.googlePlaceId,
                                    addressLine: viewModel.location.addressLine,
                                    locationId: viewModel.location.locationId,
                                    locationName: viewModel.location.locationName,
                                  )));
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
