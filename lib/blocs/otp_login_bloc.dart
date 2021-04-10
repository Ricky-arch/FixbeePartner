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
    if (event == OtpEvents.updateFcmToken) {
      return await updateFcmToken();
    }
    if (event == OtpEvents.resendOtp) {
      return await resendOtp(message);
    }
    return latestViewModel;
  }

  @override
  OtpModel setTrackingFlag(OtpEvents event, bool loading, Map message) {
    if (event == OtpEvents.onOtpVerify)
      return latestViewModel..verifying = loading;
    if (event == OtpEvents.fetchSaveBeeDetails)
      return latestViewModel..fetchingAllBeeConfiguration = loading;
    else if (event == OtpEvents.resendOtp)
      return latestViewModel..resendingOtp = loading;

    return latestViewModel;
  }

  Future<OtpModel> _onOtpVerify(String phone, String otp) async {
    String query = '''
    mutation {
  login(input:{
    select:{ phone: "$phone" }
    secret: { otp: "$otp" }
  }) {
    token
  }
}
    ''';
    try {
      Map response;
      response = await CustomGraphQLClient.instance.mutate(query);
      String token = response['login']['token'];
      print(token);
      await _saveToken(token);
      CustomGraphQLClient.instance.reinstantiate(token);
      DataStore.token = token;
      return latestViewModel..valid = true;
    } catch (e) {
      print(e);
      return latestViewModel..valid = false;
    }
  }

  _saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.TOKEN, token);
  }

  Future<OtpModel> checkForServiceSelected() async {
    String query = '''{profile{
  services{
    id
  }
}}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List services = response['profile']['services'];
    if (services.length != 0) return latestViewModel..serviceSelected = true;
    return latestViewModel;
  }

  Future<OtpModel> fetchSaveBeeDetails() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String fcmToken = await _firebaseMessaging.getToken();
    DataStore.fcmToken = fcmToken;
    log(fcmToken, name: 'FCM TOKEN');

    String query = '''mutation{
  update(input:{fcmToken:"$fcmToken"}){
     name {
     firstName
     middleName
     lastName
   }
   displayPicture
   documentsVerified
   email
   emailVerified
   active
   phone
   services{id}
   phoneVerified
   personalDetails {
     dateOfBirth
     gender
   }
  }
}''';

    Map response;
    response = await CustomGraphQLClient.instance.mutate(query);
    Map beeProfile = response['update'];
    var myRating = await getRating();
    var walletAmount;
    try {
      walletAmount = await getWallet();
    } catch (e) {
      return latestViewModel
        ..walletError = true
        ..errorMessage = e.toString();
    }
    Bee bee = Bee()
      ..firstName = beeProfile['name']['firstName']
      ..middleName = beeProfile['name']['middleName'] ?? ''
      ..lastName = beeProfile['name']['lastName'] ?? ''
      ..verified = beeProfile['documentsVerified']
      ..walletAmount = 00
      ..active = beeProfile['active']
      ..dpUrl = (beeProfile['displayPicture'] == null)
          ? null
          : EndPoints.DOCUMENT + beeProfile['displayPicture']
      ..myRating = myRating.toString()
      ..walletAmount = walletAmount
      ..phoneNumber = beeProfile['phone'];
    DataStore.me = bee;
    DataStore.fcmToken = beeProfile['fcmToken'];
    if (beeProfile['services'].length == 0)
      latestViewModel.serviceSelected = false;
    else
      latestViewModel.serviceSelected = true;
    return latestViewModel
      ..bee = bee
      ..gotBeeDetails = true;
  }

  Future<OtpModel> updateFcmToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String fcmToken = await _firebaseMessaging.getToken();
    DataStore.fcmToken = fcmToken;
    log(fcmToken, name: 'FCM TOKEN');
    String query = '''mutation{
  update(input:{fcmToken:"$fcmToken"}){
    fcmToken
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  Future<OtpModel> resendOtp(Map<String, dynamic> message) async {
    String query = '''mutation {
  sendOtp(input:{phone:"${message['phone']}"}) {
    phone
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  getRating() async {
    String query = '''{
  rating{
    avg
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    var myRating = response['rating']['avg'];
    return myRating;
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
}
