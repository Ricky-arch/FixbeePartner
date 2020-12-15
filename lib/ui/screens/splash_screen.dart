import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/splash_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/splash_model.dart';
import 'package:fixbee_partner/ui/custom_widget/no_internet_widget.dart';
import 'package:fixbee_partner/ui/custom_widget/splash_widget.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  SplashBloc _bloc;

  bool onLaunch = false;

  bool hideIcon = false;
  Position _currentPosition;



  void _setupFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_MESSAGE');
      },
      onResume: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_RESUME');
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
          return NavigationScreen();
        }));
      },
      onLaunch: (message) async {
        log(message.toString(), name: 'ON_LAUNCH');
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
          return NavigationScreen();
        }));
      },
    );
  }

  @override
  void initState() {
    _setupFCM();
    _bloc = SplashBloc(SplashModel());
    _bloc.fire(Event(100), onHandled: (e, m) {
      if (m.connection) {
        if (m.tokenFound) {
          if (m?.me?.services == null || m.me.services.length == 0) {
            log("SERVICE SELECTED", name: "SELECTED");
            try {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: ServiceSelectionScreen()));
            } catch (e) {}
          } else {


            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: NavigationScreen()));
          }
        } else
          Navigator.pushReplacement(context,
              PageTransition(type: PageTransitionType.fade, child: Login()));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _bloc?.extinguish();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return (viewModel.connection)
              ? SplashWidget()
              : NoInternetWidget(
                  retryConnecting: () {
                    _bloc.fire(Event(100), onHandled: (e, m) {
                      log(m.connection.toString(), name: "CONNECTION");
                      if (m.connection) {
                        if (m.tokenFound) {
                          if (m.me.services.length == 0)
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ServiceSelectionScreen()));
                          else {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: NavigationScreen()));
                          }
                        } else
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Login()));
                      }
                    });
                  },
                  loading: _bloc.latestViewModel.tryReconnecting,
                );
        }),
      ),
    );
  }
}
