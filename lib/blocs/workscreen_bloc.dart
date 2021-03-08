import 'dart:async';
import 'dart:developer';

import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/workscreen_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../Constants.dart';
import '../bloc.dart';

class WorkScreenBloc extends Bloc<WorkScreenEvents, WorkScreenModel> {
  WorkScreenBloc(WorkScreenModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<WorkScreenModel> mapEventToViewModel(
      WorkScreenEvents event, Map<String, dynamic> message) async {
    if (event == WorkScreenEvents.verifyOtpToStartService) {
      return await verifyOtpToStartService(message);
    }
    if (event == WorkScreenEvents.rateUser) {
      return await rateUser(message);
    }
    if (event == WorkScreenEvents.onJobCompletion) {
      return await onJobCompletion(message);
    }
    if (event == WorkScreenEvents.checkActiveOrderStatus) {
      return await checkActiveOrderStatus();
    }
    if (event == WorkScreenEvents.refreshOrderDetails) {
      return await refreshOrderDetails(message);
    }

    if (event == WorkScreenEvents.updateLiveLocation) {
      return await updateLiveLocation(message);
    }
    else if(event== WorkScreenEvents.receivePayment){
      return await receivePayment();
    }
    return latestViewModel;
  }

  Future<WorkScreenModel> verifyOtpToStartService(
      Map<String, dynamic> message) async {
    String otp = message['otp'];

    String query = '''mutation{
  verifyOrder(input:{otp:"$otp"}){
    status
  }
}''';
    Map response;
    try {
      response = await CustomGraphQLClient.instance.mutate(query);
      return latestViewModel
        ..otpValid = true
        ..onServiceStarted = response['verifyOrder']['status'];
    } catch (e) {
      return latestViewModel..otpValid = false;
    }
  }

  Future<WorkScreenModel> rateUser(Map<String, dynamic> message) async {
    String accountID = message['accountID'];
    int score = message['Score'];
    String review = message['Review'];

    String query = '''
    mutation{
  AddRating(input:{AccountId:"$accountID", Score:$score, Remark:"$review"}){
    Score
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  Future<WorkScreenModel> onJobCompletion(Map<String, dynamic> message) async {
    String id = message['orderID'];
    String processOrder = '''mutation{
  ProcessOrder(_id:"$id"){
    ID
  }
}
    ''';
    Map processResponse =
        await CustomGraphQLClient.instance.mutate(processOrder);
    String completeOrder = '''mutation{
  CompleteOrder(_id:"$id"){
    ID
    Status
  }
}''';
    Map completeResponse =
        await CustomGraphQLClient.instance.mutate(completeOrder);
    if (completeResponse['CompleteOrder']['Status'] == 'COMPLETED')
      latestViewModel..onJobCompleted = true;
    return latestViewModel;
  }

  Future<WorkScreenModel> checkActiveOrderStatus() async {
    String query = '''{
  activeOrder{
    status
  }
}''';

    Map response = await CustomGraphQLClient.instance.query(query);

    return latestViewModel
      ..activeOrderStatus = response['activeOrder']['status'];
  }

  Future<WorkScreenModel> refreshOrderDetails(
      Map<String, dynamic> message) async {
    String query = '''{
  activeOrder{
    addons{
      name
      quantity
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    try {
      List<Service> addOns = [];
      if (response['activeOrder']['addons'].length != 0) {
        for (Map addOn in response['activeOrder']['addons']) {
          Service s = Service();
          s.serviceName = addOn['name'];
          s.quantity = addOn['quantity'];
          addOns.add(s);
        }
      }
      return latestViewModel..ordersModel.addOns = addOns;
    } catch (e) {
      return latestViewModel;
    }
  }

  Timer locationTimer;
  startTimer() {
    log("WORK TIMER STARTED", name: "TS");
    var timeOut = Constants.updateLocationTimeOut;
    Position location;
    locationTimer = Timer.periodic(Duration(seconds: timeOut), (timer) async {
      try {
        location = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        await updateLiveLocation(
            {'latitude': location.latitude, 'longitude': location.longitude});
      } catch (e) {
        location = null;
      }
    });
  }

  endTimer() {
    log("WORK TIMER ENDED", name: "TS");
    locationTimer.cancel();
  }

  Future<WorkScreenModel> updateLiveLocation(
      Map<String, dynamic> message) async {
    double latitude = message['latitude'];
    double longitude = message['longitude'];
    String query = '''mutation {
  updateLiveLocation(input:{
    lat: $latitude
    lng: $longitude
  }){
    lat
    lng
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  Future<WorkScreenModel> receivePayment() async{
    String query='''
    mutation{
  receivePayment {
    column
    amount
    currency
    referenceId
    faId
    payment {
      amount
      currency
      status
      method
      refund_status
      amount_refunded
      captured
    }
    payout {
      amount
      currency
      status
      mode
      utr
    }
    paymentId
    payoutId
    createdAt
  }
}
    ''';
    try{
      Map response= await CustomGraphQLClient.instance.query(query);
      return latestViewModel..paymentReceived=true;

    }
    catch(e){
      print(e);
      return latestViewModel..paymentReceived=false;
    }

  }
}
