import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/navigation_bloc.dart';
import 'package:fixbee_partner/blocs/splash_bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bottom_nav_bar.dart';
import 'package:fixbee_partner/ui/custom_widget/job_notification.dart';
import 'package:fixbee_partner/ui/screens/home.dart';
import 'package:fixbee_partner/ui/screens/profile.dart';
import 'package:fixbee_partner/ui/screens/profile_new.dart';

import 'package:fixbee_partner/ui/screens/wallet_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'history.dart';

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
  ProfileNew(),
];

class _NavigationScreenState extends State<NavigationScreen> {
  NavigationBloc _bloc;
  String _jobId="";
  int _currentIndex = 0;
  bool _gotJob;
//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//  void _getMessage() {
//
//    _firebaseMessaging.configure(
//        onMessage: (Map<String, dynamic> message) async {
//
//          log(message.toString(), name: "ON MESSAGE");
//          setState(() {
//            _orderId=message['notification']['data']['id'].toString();
//            _gotJob = true;
//          });
//        },
//        onBackgroundMessage: myBackgroundMessageHandler,
//        onResume: (Map<String, dynamic> message) async {
//          log(message.toString(), name: "ON RESUME");
//          setState(() {
//            _gotJob = true;
//          });
//        },
//        onLaunch: (message) async {
//          log(message.toString(), name: "ON LAUNCH");
//          Scaffold.of(context).showSnackBar(
//            SnackBar(
//              content: Text(
//                message.toString(),
//              ),
//            ),
//          );
//        });
//  }

  @override
  void initState() {
    _bloc=NavigationBloc(NavigationModel());
    _bloc.fire(NavigationEvent.gotJobNotificationID, onHandled: (e,m){
      _jobId=m.jobId;
    });
    _gotJob = widget.gotJob;
   // _getMessage();
    super.initState();
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
        child: _bloc.widget(onViewModelUpdated: (ctx, viewModel){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: pages[_currentIndex]),

              _gotJob
                  ? JobNotification(
                startTimer: (){

                },
                onConfirm: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WorkScreen()));
                },
                onDecline: () {
                  setState(() {
                    _gotJob = false;
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
