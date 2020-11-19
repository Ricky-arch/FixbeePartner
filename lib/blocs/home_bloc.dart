import 'dart:async';
import 'dart:developer';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/home_events.dart';
import 'package:fixbee_partner/models/home_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'flavours.dart';

class HomeBloc extends Bloc<HomeEvents, HomeModel>
    with Trackable<HomeEvents, HomeModel>, SecondaryStreamable<HomeModel> {
  HomeBloc(HomeModel genesisViewModel) : super(genesisViewModel) ;

  Timer locationTimer;
  StreamSubscription locationStream;

  @override
  Future<HomeModel> mapEventToViewModel(
      HomeEvents event, Map<String, dynamic> message) async {
    if (event == HomeEvents.activityStatusSet) {
      return await _setActivityStatus(message);
    } else if (event == HomeEvents.activityStatusRequested) {
      return await _getActivityStatus();
    } else if (event == HomeEvents.updateLiveLocation) {
      return await updateLiveLocation(message);
    } else if (event == HomeEvents.getDeviceLocation) {
      return await getLiveLocation();
    }
    if (event == HomeEvents.getDocumentVerificationStatus) {
      return await _getDocumentVerificationStatus();
    }
    if (event == HomeEvents.getDeviceLocation) {
      return await _getDeviceLocation();
    }

    return latestViewModel;
  }

  Future<HomeModel> _getDocumentVerificationStatus() async {
    String query = '''{
  Me{
    ... on Bee{
      DocumentVerification{
      Status
      }
    }
  }
} ''';
    Map response = await CustomGraphQLClient.instance.query(query);

    return latestViewModel
      ..verifiedBee = response['Me']['DocumentVerification']['Status'];
  }

  Future<HomeModel> _setActivityStatus(Map<String, dynamic> message) async {
    bool status = message['status'];
    String query = '''mutation{
  Update(input:{SetActive:$status}){
    ... on Bee{
      Active
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);

    return latestViewModel
      ..activeStatus = response['Update']['Active'] ?? false;
  }

  Future<HomeModel> _getActivityStatus() async {
    String query = '''{
  Me{
    ... on Bee{
      Active
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    log(response['Me']['Active'].toString(), name: "activee");
    return latestViewModel..activeStatus = response['Me']['Active'];
  }

  Future<HomeModel> updateLiveLocation(Map<String, dynamic> message) async {
    double latitude = message['latitude'];
    double longitude = message['longitude'];
    String query = '''mutation {
  Update(input:{UpdateLiveLocation:{Latitude: $latitude, Longitude: $longitude}}){
    ... on Bee{
      ID
      LiveLocation{
        Latitude
        Longitude
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel
      ..latitude = response['Update']['LiveLocation']['Latitude']
      ..latitude = response['Update']['LiveLocation']['Longitude'];
  }

  @override
  HomeModel setTrackingFlag(HomeEvents event, bool loading, Map message) {
    if (event == HomeEvents.activityStatusSet ||
        event == HomeEvents.activityStatusRequested) {
      return latestViewModel..loading = loading;
    }
    return latestViewModel;
  }

  subscribeToLocationUpdate(Function(Position) onUpdateLocation) {
    Position location;


    locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      log("Location Updated", name: "LOCATION1");
      Position location = await _getLocation();
      updateLiveLocation(
          {'latitude': location.latitude, 'longitude': location.longitude});
    });
  }

  unsubscribeToLocationUpdate() {
    if (locationStream != null) {
      log('CANCELLED', name: 'CAN');
      locationStream.cancel();
    }
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<HomeModel> _getDeviceLocation() async {
    Position location = await _getLocation();

    return latestViewModel
      ..latitude = location.latitude
      ..longitude = location.longitude;
  }

  @override
  HomeModel mapSubResultToModel(Map result) {
    return latestViewModel;
  }

  @override
  void onExtinguish() {
    CustomGraphQLClient.instance.invalidateWSClient();
  }

  Future<HomeModel> getLiveLocation() async {
    String query = '''{
  Me{
    ...on Bee{
      LiveLocation{
        Latitude
        Longitude
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    return latestViewModel
      ..latitude =
          double.parse(response['Me']['LiveLocation']['Latitude'].toString()) ??
              23.829321
      ..latitude = double.parse(
              response['Me']['LiveLocation']['Longitude'].toString()) ??
          91.277847;
  }
}
