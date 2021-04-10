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
  SplashBloc(ViewModel genesisViewModel) : super(genesisViewModel);

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

    MetaData metadata = await getMetaData();
    latestViewModel..metadata = metadata;
    DataStore.metaData = metadata;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(SharedPrefKeys.TOKEN)) {
      String token = pref.getString(SharedPrefKeys.TOKEN);
      DataStore.token = token;
      CustomGraphQLClient.instance.reinstantiate(token);
      Map dynamicData = await queryBee(token);
      if (dynamicData['hasError'])
        return latestViewModel
          ..errorMessage = dynamicData['errorMessage']
          ..metadata = metadata
          ..hasError = true;
      else
        return latestViewModel
          ..me = dynamicData['bee']
          ..tokenFound = true
          ..metadata = metadata;
    }
    return latestViewModel
      ..tokenFound = false
      ..metadata = metadata;
  }

  bool hasErrorOnFetchProfile = false;
  String errorMessage;

  Future<Map<String, dynamic>> queryBee(String token) async {
    Map<String, dynamic> dynamicData = {};
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
  rating{
    avg
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
          : EndPoints.DOCUMENT + response['profile']['displayPicture'];
      bee = Bee()
        ..firstName = name['firstName']
        ..middleName = name['middleName'] ?? ''
        ..lastName = name['lastName'] ?? ''
        ..phoneNumber = response['profile']['phone']
        ..verified = response['profile']['documentsVerified']
        ..dpUrl = dpUrl
        ..active =
            response['profile']['active'].toString().toLowerCase() == 'true'
        ..myRating = response['rating']['avg'].toString()
        ..walletAmount = response['wallet']['amount']
        ..services = services.map((service) {
          if (service != null)
            return ServiceOptionModel()
              ..id = service['id']
              ..serviceName = service['name'];
        }).toList();
      log(bee.active.toString(), name: "ACTIVE");
      DataStore.me = bee;
      dynamicData['bee'] = bee;
      dynamicData['hasError'] = false;
      return dynamicData;
    } catch (e) {
      dynamicData['hasError'] = true;
      dynamicData['errorMessage'] = e.toString();
      return dynamicData;
    }
  }

  @override
  SplashModel setTrackingFlag(Event event, bool trackFlag, Map message) {
    if (event == Event(100)) latestViewModel..tryReconnecting = trackFlag;
    return latestViewModel;
  }

  getWallet() async {
    String query = '''
    {
  wallet{
    amount
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    var walletAmount = response['wallet']['amount'];
    return walletAmount;
  }

  getMetaData() async {
    String query = '''
    {
  metadata {
    helpline
    email
    officeTimings
    available
    appBuildNumber
    criticalUpdate
    minWalletAmount
    minWalletDeposit
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    response = response['metadata'];

    MetaData metaData = MetaData();
    metaData.buildNumber = response['appBuildNumber'];
    metaData.helpline = response['helpline'];
    metaData.email = response['email'];
    metaData.available=response['available'];
    metaData.criticalUpdate = response['criticalUpdate'];
    metaData.minimumWalletAmount = response['minWalletAmount'];
    metaData.minimumWalletDeposit = response['minWalletDeposit'];
    List<String> officeTimings = [];
    List oT = response['officeTimings'];
    oT.forEach((ot) {
      String timing = ot.toString();
      officeTimings.add(timing);
    });
    metaData.officeTimings = officeTimings;
    return metaData;
  }
}
