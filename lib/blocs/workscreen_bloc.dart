import 'dart:developer';

import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/workscreen_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../Constants.dart';
import '../bloc.dart';

class WorkScreenBloc extends Bloc<WorkScreenEvents, WorkScreenModel> {
  WorkScreenBloc(WorkScreenModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<WorkScreenModel> mapEventToViewModel(
      WorkScreenEvents event, Map<String, dynamic> message) async {
    if (event == WorkScreenEvents.fetchOrderDetails) {
      return await fetchOrderDetails(message);
    }
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
      return await checkActiveOrderStatus(message);
    }
    if (event == WorkScreenEvents.refreshOrderDetails) {
      return await refreshOrderDetails(message);
    }
    return latestViewModel;
  }

  Future<WorkScreenModel> fetchOrderDetails(
      Map<String, dynamic> message) async {
    String id = message['order_id'];
    String query = '''{Order(_id:"$id"){
  Location{
    Address{
      Line1
    }
    GooglePlaceID
    Name
  }
  Amount
  OTP
  Service{
    Name
    ID
  }
  CashOnDelivery
  Timestamp
  User{
    ID
    Name{
      Firstname
      Middlename
      Lastname
    }
    DisplayPicture{
      filename
      mimetype
      encoding
    }
    Ratings{
      Score
    }
    Phone{
      Number
    }
  }
}}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    Map order = response['Order'];
    Map user = order['User'];
    Map location = order['Location'];
    print(location['Address']['Line1'] + "llll");

    return latestViewModel
      ..jobModel.userFirstname = user['Name']["Firstname"]
      ..jobModel.userMiddlename = user['Name']["Middlename"]
      ..jobModel.userLastname = user['Name']["Lastname"]
      ..jobModel.userPhoneNumber = user['Phone']['Number']
      ..jobModel.serviceName = response['Order']['Service']["Name"]
      ..jobModel.address = location['Address']['Line1']
      ..jobModel.googlePlaceId = location['GooglePlaceID']
      ..jobModel.userProfilePicUrl =
          '${EndPoints.DOCUMENT}?id=${user['DisplayPicture']['id']}'
      ..jobModel.totalAmount = order['Amount']
      ..jobModel.cashOnDelivery = order['CashOnDelivery']
      ..jobModel.timeStamp = order['Timestamp'];
  }

  Future<WorkScreenModel> verifyOtpToStartService(
      Map<String, dynamic> message) async {
    String id = message['orderId'];
    String otp = message['otp'];

    String query = '''mutation{
  ResolveOrder(_id:"$id",input:{OTP:"$otp"}){
    Status
  }
}''';
    Map response;
    try {
      response = await CustomGraphQLClient.instance.mutate(query);
      if (response['ResolveOrder']['Status'] == 'RESOLVED')
        latestViewModel
          ..orderResolved = true
          ..otpValid = true
          ..activeOrderStatus = "RESOLVED";
      else if (response.containsKey("errors"))
        latestViewModel..otpValid = false;
    } catch (e) {
      latestViewModel..otpInvalidMessage = response['message'];
    }
    log(response['ResolveOrder']['Status'].toString(), name: "AOS");
    return latestViewModel;
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

  Future<WorkScreenModel> checkActiveOrderStatus(
      Map<String, dynamic> message) async {
    String id = message['orderID'];
    String query = '''{
  Order(_id:"$id"){
    Status
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    return latestViewModel..activeOrderStatus = response['Order']['Status'];
  }

  Future<WorkScreenModel> refreshOrderDetails(
      Map<String, dynamic> message) async {
    String orderID = message['orderID'];
    String query = '''{Order(_id:"$orderID"){
  Service{
    Name
  }
  Addons{
    Service{
      Name
      Pricing{
        BasePrice
        ServiceCharge
        TaxPercent
      }
    }
    Amount
  }
}}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    latestViewModel.jobModel.addons = [];
    List addons = response['Order']['Addons'];
    for (Map addon in addons) {
      Service service = Service()
        ..serviceName = addon['Service']['Name']
        ..basePrice = addon['Service']['Pricing']['BasePrice']
        ..serviceCharge = addon['Service']['Pricing']['ServiceCharge']
        ..taxPercent = addon['Service']['Pricing']['TaxPercent']
        ..amount = addon['Amount'];
      latestViewModel.jobModel.addons.add(service);
    }
    return latestViewModel;
  }
}
