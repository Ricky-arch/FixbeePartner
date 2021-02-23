import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/splash_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/splash_model.dart';
import 'package:fixbee_partner/ui/custom_widget/no_internet_widget.dart';
import 'package:fixbee_partner/ui/custom_widget/splash_widget.dart';
import 'package:fixbee_partner/ui/screens/all_service_selection_screen.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';
import 'login.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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

  Box _BEENAME;

  void _setupFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_MESSAGE');
      },
      onResume: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_RESUME');
        FlutterRingtonePlayer.playNotification();
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
          return NavigationScreen();
        }));
      },
      onLaunch: (message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_LAUNCH');
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
          return NavigationScreen();
        }));
      },
    );
  }

  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  _openHive() async {
    await Hive.openBox<String>("BEE");
    _BEENAME = Hive.box<String>("BEE");
  }

  void refreshAllData(Bee bee) {
    _BEENAME.put("myPhone", bee.phoneNumber);
    _BEENAME.put(
        ("myName"), getMyName(bee.firstName, bee.middleName, bee.lastName));
    _BEENAME.put("myDocumentVerification", (bee.verified) ? "true" : "false");
    _BEENAME.put("dpUrl", bee.dpUrl);
    _BEENAME.put("myActiveStatus", (bee.active) ? "true" : "false");
    _BEENAME.put("myWallet", bee.walletAmount.toString());
  }

  @override
  void initState() {
    _setupFCM();
    _openHive();

    _bloc = SplashBloc(SplashModel());
    _bloc.fire(Event(100), onHandled: (e, m) {
      if (m.connection) {
        if (m.tokenFound) {
          if (_BEENAME.containsKey('myPhone')) {
            if (m.me.phoneNumber != _BEENAME.get('myPhone'))
              refreshAllData(m.me);
          } else
            _BEENAME.put('myPhone', m.me.phoneNumber);
          if (!_BEENAME.containsKey("myName"))
            _BEENAME.put(("myName"),
                getMyName(m.me.firstName, m.me.middleName, m.me.lastName));
          if (!_BEENAME.containsKey("myDocumentVerification"))
            _BEENAME.put(
                "myDocumentVerification", (m.me.verified) ? "true" : "false");
          if (!_BEENAME.containsKey("dpUrl")) _BEENAME.put("dpUrl", m.me.dpUrl);
          if (!_BEENAME.containsKey("myActiveStatus"))
            _BEENAME.put("myActiveStatus", (m.me.active) ? "true" : "false");
          // if (!_BEENAME.containsKey("myWallet"))
          _BEENAME.put("myWallet", m.me.walletAmount.toString());
          if (m?.me?.services == null || m.me.services.length == 0) {
            log("SERVICE SELECTED", name: "SELECTED");
            try {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: AllServiceSelection()));
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
    //Hive.close();
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
                      print(m.me.firstName);
                      print(m.me.services.length.toString());
                      print(m.tokenFound.toString());
                      log(m.connection.toString(), name: "CONNECTION");
                      if (m.connection) {
                        if (m.tokenFound) {
                          if (m.me.services.length == 0)
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: AllServiceSelection()));
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
