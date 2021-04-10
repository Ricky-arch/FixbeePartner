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
    with Trackable<HomeEvents, HomeModel> {
  HomeBloc(HomeModel genesisViewModel) : super(genesisViewModel);

  Timer locationTimer;

  void Function(bool) onSwitchChange;

  @override
  Future<HomeModel> mapEventToViewModel(
      HomeEvents event, Map<String, dynamic> message) async {
    if (event == HomeEvents.activityStatusSet) {
      return await _setActivityStatus(message);
    } else if (event == HomeEvents.activityStatusRequested) {
      return await _getActivityStatus();
    }
    // else if (event == HomeEvents.updateLiveLocation) {
    //   return await updateLiveLocation(message);
    // } else if (event == HomeEvents.getDeviceLocation) {
    //   return await getLiveLocation();
    // }
    else if (event == HomeEvents.getDocumentVerificationStatus) {
      return await _getDocumentVerificationStatus();
    }
    // if (event == HomeEvents.getDeviceLocation) {
    //   return await _getDeviceLocation();
    // }

    return latestViewModel;
  }

  Future<HomeModel> _getDocumentVerificationStatus() async {
    String query = '''{
  profile{
    documentsVerified
  }
}''';
    Map response;
    try {
      response = await CustomGraphQLClient.instance.query(query);
      return latestViewModel
        ..verifiedBee = response['profile']['documentsVerified'];
    } catch (e) {
      print(e);
      return latestViewModel;
    }
  }

  Future<HomeModel> _setActivityStatus(Map<String, dynamic> message) async {
    bool status = message['status'];
    String query = '''mutation{
  update(input:{active:$status}){
    active
  }
}''';
    Map response;
    try {
      response = await CustomGraphQLClient.instance.query(query);
      return latestViewModel
        ..activeStatus = response['update']['active'] ?? false;
    } catch (e) {
      print(e);
      return latestViewModel;
    }
  }

  Future<HomeModel> _getActivityStatus() async {
    String query = '''{
  profile{
    active
    documentsVerified
  }
}''';
    Map response;
    try {
      response = await CustomGraphQLClient.instance.query(query);
      log(response['profile']['active'].toString(), name: "activee");
      onSwitchChange(response['profile']['active']);
      return latestViewModel..activeStatus = response['profile']['active'];
    } catch (e) {
      print(e);
      return latestViewModel;
    }
  }

  @override
  HomeModel setTrackingFlag(HomeEvents event, bool loading, Map message) {
    if (event == HomeEvents.activityStatusSet ||
        event == HomeEvents.activityStatusRequested) {
      return latestViewModel..loading = loading;
    }
    return latestViewModel;
  }

}
