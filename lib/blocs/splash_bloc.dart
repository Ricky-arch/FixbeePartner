import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/splash_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_store.dart';

class SplashBloc extends Bloc<Event, SplashModel>
    with Trackable<Event, SplashModel> {
  SplashBloc(ViewModel genesisViewModel) : super(genesisViewModel) {
    getMessage();
  }

  @override
  Future<SplashModel> mapEventToViewModel(
      Event event, Map<String, dynamic> message) async {
    log('Splash');
    return await _fetchToken();
  }

  Future<bool> __ping(String address) async {
    try {
      final result = await InternetAddress.lookup(address);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<SplashModel> _fetchToken() async {
    bool internet = await __ping(Constants.HOST_IP);
    log(internet.toString(), name: "INTERNET");
    if (!internet)
      return latestViewModel..connection = false;
    else
      latestViewModel.connection = true;

    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(SharedPrefKeys.TOKEN)) {
      String token = pref.getString(SharedPrefKeys.TOKEN);
      log(token, name: 'TOKEN');
      DataStore.token = token;
      Bee bee = await _checkToken(token);
      return latestViewModel
        ..me = bee
        ..tokenFound = true;
    }
    return latestViewModel..tokenFound = false;
  }

  Future<Bee> _checkToken(String token) async {
    String query = '''
    {
  Me {
    ... on Bee {
      ID
      DocumentVerification {
        Status
      }
      Wallet {
        Amount
      }
      Active
      Ratings {
        Score
      }
      DisplayPicture {
        id
      }
      Services {
        ID
        Name
      }
      Name {
        Firstname
        Middlename
        Lastname
      }
      Phone {
        Number
        Verified
      }
    }
  }
}


    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    Bee bee;

    Map name = response['Me']['Name'];
    Map phone = response['Me']['Phone'];
    List services = response['Me']['Services'] ?? [];
    String dpUrl = (response['Me']['DisplayPicture']['id'] == null)
        ? null
        : EndPoints.DOCUMENT + '?id=' + response['Me']['DisplayPicture']['id'];

    bee = Bee()
      ..firstName = name['Firstname']
      ..middleName = name['Middlename'] ?? ''
      ..lastName = name['Lastname'] ?? ''
      ..phoneNumber = phone['Number']
      ..verified = response['Me']['DocumentVerification']['Status']
      ..dpUrl = dpUrl
      ..walletAmount = response['Me']['Wallet']['Amount']
      ..id=response['Me']['ID']
      ..active = response['Me']['Active'].toString().toLowerCase() == 'true'
      ..services = services.map((service) {
        if (service != null)
          return ServiceOptionModel()
            ..id = service['ID']
            ..serviceName = service['Name'];
      }).toList();
    log(bee.active.toString(), name: "ACTIVE");
    DataStore.me = bee;
    return bee;
  }

  void getMessage() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  SplashModel setTrackingFlag(Event event, bool trackFlag, Map message) {
    if (event == Event(100)) latestViewModel..tryReconnecting = trackFlag;
    return latestViewModel;
  }
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
