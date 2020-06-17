import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:flutter/material.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationModel> with Trackable<NavigationEvent, NavigationModel>{
  NavigationBloc(NavigationModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<NavigationModel> mapEventToViewModel(NavigationEvent event, Map<String, dynamic> message) {
    FirebaseMessaging _fireBaseMessaging= FirebaseMessaging();
    void _getMessage() {
      _fireBaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            log(message.toString(), name: "ON MESSAGE");

          },
          onBackgroundMessage: myBackgroundMessageHandler,
          onResume: (Map<String, dynamic> message) async {
            log(message.toString(), name: "ON RESUME");

          },
          onLaunch: (message) async {
            log(message.toString(), name: "ON LAUNCH");

            
          });
    }

    // TODO: implement mapEventToViewModel
    throw UnimplementedError();
  }

  @override
  NavigationModel setTrackingFlag(NavigationEvent event, bool trackFlag, Map message) {
    // TODO: implement setTrackingFlag
    return latestViewModel;
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
    log(message.toString(), name: "ON BACKGROUND");
    // Or do other work.
    return Future.value(true);
  }


}