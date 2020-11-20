import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/animations/faded_animations.dart';
import 'package:fixbee_partner/blocs/splash_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/splash_model.dart';
import 'package:fixbee_partner/ui/custom_widget/no_internet_widget.dart';
import 'package:fixbee_partner/ui/custom_widget/splash_widget.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;
  bool onLaunch = false;

  bool hideIcon = false;
  Position _currentPosition;

  _getCurrentLocation() {

    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

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
            _getCurrentLocation();
            if (_currentPosition != null)
              DataStore.beePosition = _currentPosition;

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
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _positionController.forward();
            }
          });

    _positionController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              _scale2Controller.forward();
            }
          });

    _scale2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _scale2Animation = Tween<double>(begin: 1.0, end: 32.0).animate(
        _scale2Controller)
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          if (_bloc.latestViewModel.tokenFound)
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: ServiceSelectionScreen()));
          else
            Navigator.push(context,
                PageTransition(type: PageTransitionType.fade, child: Login()));
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.extinguish();
    _scaleController.dispose();
    _scale2Controller.dispose();
    _widthController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

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
                            _getCurrentLocation();
                            if (_currentPosition != null)
                              DataStore.beePosition = _currentPosition;

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
