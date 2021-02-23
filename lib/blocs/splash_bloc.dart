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
      DataStore.token = token;
      log(DataStore.token, name: 'TOKEN');
      CustomGraphQLClient.instance.reinstantiate(token);
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
  profile{
    name{
      firstName
      middleName
      lastName
    }
    documentsVerified
    displayPicture
    email
    phone
    services{id}
    active
    canReceiveOrders
    services{
      id
      name
    }
  }
  wallet{
    amount
  }
}
    ''';

    try {
      Bee bee;
      Map response = await CustomGraphQLClient.instance.query(query);
      Map name = response['profile']['name'];
      List services = response['profile']['services'] ?? [];
      String dpUrl = (response['profile']['displayPicture'] == null)
          ? null
          : EndPoints.DOCUMENT + '?id=' + response['profile']['displayPicture'];
      bee = Bee()
        ..firstName = name['firstName']
        ..middleName = name['middleName'] ?? ''
        ..lastName = name['lastName'] ?? ''
        ..phoneNumber = response['profile']['phone']
        ..verified = response['profile']['documentsVerified']
        ..dpUrl = dpUrl
        ..walletAmount = response['wallet']['amount']
        ..active =
            response['profile']['active'].toString().toLowerCase() == 'true'
        ..services = services.map((service) {
          if (service != null)
            return ServiceOptionModel()
              ..id = service['id']
              ..serviceName = service['name'];
        }).toList();
      log(bee.active.toString(), name: "ACTIVE");
      DataStore.me = bee;
      return bee;
    } catch (e) {
      print(e);
      return Bee();
    }
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
