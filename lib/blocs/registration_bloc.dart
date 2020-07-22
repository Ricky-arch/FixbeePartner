import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/registration_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/registration_model.dart';
import 'package:fixbee_partner/utils/request_maker.dart';
import '../data_store.dart';
import 'flavours.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationModel>
    with Trackable<RegistrationEvents, RegistrationModel> {
  RegistrationBloc(RegistrationModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<RegistrationModel> mapEventToViewModel(
      RegistrationEvents event, Map<String, dynamic> message) async {
    if (event == RegistrationEvents.registrationFieldSet) {
      return await registerBee(message);
    } else if (event == RegistrationEvents.requestOtp) {
      return await requestOtp(message);
    }
    return latestViewModel;
  }

  @override
  RegistrationModel setTrackingFlag(
      RegistrationEvents event, bool loading, Map message) {
    // TODO: implement setTrackingFlag
    return latestViewModel;
  }

  Future<RegistrationModel> registerBee(Map<String, dynamic> message) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String fcmToken = await _firebaseMessaging.getToken();
    DataStore.fcmToken = fcmToken;
    log(fcmToken, name: 'FCM TOKEN');
    Map response = await RequestMaker(endpoint: EndPoints.REGISTER, body: {
      'name': {
        'firstname': message['firstname'],
        'middlename': message['middlename'],
        'lastname': message['lastname']
      },
      'fcm_token': fcmToken,
      'phone': message['phonenumber'],
      'dob': message['dateofbirth']
    }).makeRequest();
    Bee bee = Bee()
      ..firstName = message['firstname']
      ..middleName = message['middlename'] ?? ''
      ..lastName = message['lastname'] ?? ''
      ..phoneNumber = message['number']
      ..verified = message['verified'];

    DataStore.me = bee;
    print(response.containsValue('created'));
    print('Null : ${latestViewModel == null}');

    if (response.containsKey('created')) {
      return (latestViewModel..registered = true);
    } else
      return (latestViewModel..registered = false);
  }

  Future<RegistrationModel> requestOtp(Map<String, dynamic> message) async {
    Map responseOtp = await RequestMaker(
        endpoint: EndPoints.REQUEST_OTP,
        body: {'phone': message['phonenumber']}).makeRequest();
    if (responseOtp.containsKey('sent') && responseOtp['sent']) {
      log(responseOtp['otp'], name: "OTP");
      return latestViewModel..sent = true;
    } else
      return latestViewModel..sent = false;
  }
}
