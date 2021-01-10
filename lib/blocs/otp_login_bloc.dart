import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/otp_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/otp_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:fixbee_partner/utils/request_maker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flavours.dart';

class OtpLoginBloc extends Bloc<OtpEvents, OtpModel>
    with Trackable<OtpEvents, OtpModel> {
  OtpLoginBloc(OtpModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<OtpModel> mapEventToViewModel(
      OtpEvents event, Map<String, dynamic> message) async {
    if (event == OtpEvents.onOtpVerify) {
      return await _onOtpVerify(message['phone'], message['otp']);
    }
    if (event == OtpEvents.checkForServiceSelected) {
      return await checkForServiceSelected();
    }
    if (event == OtpEvents.fetchSaveBeeDetails) {
      return await fetchSaveBeeDetails();
    }
    if (event == OtpEvents.getFcmToken) {
      return await getFcmToken();
    }
    if (event == OtpEvents.resendOtp) {
      return await resendOtp(message);
    }
    return latestViewModel;
  }

  @override
  OtpModel setTrackingFlag(OtpEvents event, bool loading, Map message) {
    if (event == OtpEvents.onOtpVerify ||
        event == OtpEvents.fetchSaveBeeDetails ||
        event == OtpEvents.checkForServiceSelected)
      return latestViewModel..verifying = loading;
    else if (event == OtpEvents.resendOtp)
      return latestViewModel..resendingOtp = loading;
    return latestViewModel;
  }

  Future<OtpModel> _onOtpVerify(String phone, String otp) async {
    Map response = await RequestMaker(
        endpoint: EndPoints.LOGIN,
        body: {'phone': phone, 'otp': otp}).makeRequest();

    if (response.containsKey('error')) {
      if (response['error'] == 'OTP invalid or past expiration') {
        return latestViewModel..otpValid = false;
      }
    }

    if (response.containsKey('token')) {
      await _saveToken(response['token']);
      DataStore.token = response['token'];
      latestViewModel
        ..valid = true
        ..otpValid = true;
    }
    return latestViewModel;
  }

  _saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.TOKEN, token);
  }

  Future<OtpModel> checkForServiceSelected() async {
    String query = '''{
  Me{
    ...on Bee{
      Services{
        Name
        ID
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List services = response['Me']['Services'];
    if (services.length != 0) return latestViewModel..serviceSelected = true;
    return latestViewModel;
  }

  Future<OtpModel> fetchSaveBeeDetails() async {
    String query = '''{
  Me{
    ...on Bee{
    ID
    Active
      ID
      Name{
        Firstname
        Middlename
        Lastname
      }
      DisplayPicture {
        id
      }
      DocumentVerification{
        Status
      }
      Ratings{
        Score
      }
      Email
      Phone{Number}
      FCMToken
      DOB
      Services{
        ID
        Name
      }
      Wallet{
        Amount
      }
      BankAccounts{
        ID
        AccountNumber
        IFSC
        AccountHolderName
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    Bee bee = Bee()
      ..firstName = response['Me']['Name']['Firstname']
      ..id=response['Me']['ID']
      ..middleName = response['Me']['Name']['Middlename'] ?? ''
      ..lastName = response['Me']['Name']['Lastname'] ?? ''
      ..verified=response['Me']['DocumentVerification']['Status']
      ..walletAmount=response['Me']['Wallet']['Amount']
      ..active=response['Me']['Active'].toString().toLowerCase()=='true'
      ..dpUrl =(response['Me']['DisplayPicture']['id']==null)?null:
          EndPoints.DOCUMENT + '?id=' + response['Me']['DisplayPicture']['id']
      ..phoneNumber = response['Me']['Phone']['Number'];
    DataStore.me = bee;
    DataStore.fcmToken = response['Me']['FCMToken'];
    print("xxxxx" + response['Me']['FCMToken']);
    return latestViewModel..bee=bee;
  }

  Future<OtpModel> getFcmToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String fcmToken = await _firebaseMessaging.getToken();
    DataStore.fcmToken = fcmToken;
    log(fcmToken, name: 'FCM TOKEN');
    String query = '''mutation{
  Update(input:{
    FCMToken:"$fcmToken"
  }){
  ...on Bee{
    ID
  }
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  Future<OtpModel> resendOtp(Map<String, dynamic> message) async {
    Map response = await RequestMaker(
            endpoint: EndPoints.REQUEST_OTP, body: {'phone': message['phone']})
        .makeRequest()
        .timeout(Duration(seconds: 5));
    log(response.toString());
    return latestViewModel;
  }
}
