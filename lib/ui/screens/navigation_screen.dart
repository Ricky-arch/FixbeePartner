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
import 'history.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NavigationScreen extends StatefulWidget {
  final bool gotJob;

  const NavigationScreen({Key key, this.gotJob = false}) : super(key: key);
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

List<Widget> pages = [
  const Home(),
  const HistoryScreen(),
  const WalletScreen(),
  CustomProfile(),
];

class _NavigationScreenState extends State<NavigationScreen> {
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
      phoneNumber;
  bool slotted, paymentMode;
  @override
  void initState() {
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
      }
      if (data.containsKey('phone_number')) {
        phoneNumber = data['phone_number'];
      }
      if (data.containsKey('payment_mode')) {
        paymentMode = data['payment_mode'];
      }
    }
  }

  @override
  void dispose() {
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
                        serviceName: viewModel.service.serviceName,
                        quantity: quantityInfo,
                        userName: userName,
                        paymentMode: (paymentMode.toString() == 'false')
                            ? "Online Payment"
                            : "COD",
                        addressLine: billingAddress,
                        userNumber: phoneNumber,
                        slotted: slotted,
                        onConfirm: () {
//                        _bloc.fire(NavigationEvent.onConfirmDeclineJob,
//                            message: {
//                              "orderId": viewModel.order.orderId,
//                              "Accept": "true"
//                            });
//                        if (!viewModel.order.slotted) {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => WorkScreen(
//                                        userFirstname: viewModel.user.firstname,
//                                        userMiddlename:
//                                            viewModel.user.middlename,
//                                        userLastname: viewModel.user.lastname,
//                                        userId: viewModel.user.userId,
//                                        userProfilePicUrl:
//                                            viewModel.user.profilePicUrl,
//                                        userPhoneNumber:
//                                            viewModel.user.phoneNumber,
//                                        serviceName:
//                                            viewModel.service.serviceName,
//                                        serviceId: viewModel.service.serviceId,
//                                        cashOnDelivery:
//                                            viewModel.order.cashOnDelivery,
//                                        orderId: viewModel.order.orderId,
//                                        otp: viewModel.order.otp,
//                                        googlePlaceId:
//                                            viewModel.location.googlePlaceId,
//                                        addressLine:
//                                            viewModel.location.addressLine,
//                                        locationId:
//                                            viewModel.location.locationId,
//                                        locationName:
//                                            viewModel.location.locationName,
//                                      )));
//                        } else {
//                          setState(() {
//                            _gotJob = false;
//                          });
//                        }
                        },
                        onDecline: () {
                          setState(() {
                            _visible = false;
                          });
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
}
