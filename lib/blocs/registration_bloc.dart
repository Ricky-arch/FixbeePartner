import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/registration_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/registration_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
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
    if (event == RegistrationEvents.registration) {
      return await registerBee(message);
    } else if (event == RegistrationEvents.requestOtp) {
      return await requestOtp(message);
    }
    return latestViewModel;
  }

  @override
  RegistrationModel setTrackingFlag(
      RegistrationEvents event, bool loading, Map message) {
    return latestViewModel..loading = loading;
  }

  Future<RegistrationModel> registerBee(Map<String, dynamic> message) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String fcmToken = await _firebaseMessaging.getToken();
    DataStore.fcmToken = fcmToken;
    log(fcmToken, name: 'FCM TOKEN');
    String query='''
    mutation{
      register(input:{
        name: {
        firstName: "${message['firstName']}",
        middleName: "${message['middleName']}",
        lastName: "${message['lastName']}"
      },
      email: "${message['email']}",
      fcmToken: "$fcmToken",
      phone: "${message['phone']}",
      password:"${message['password']}",
      personalDetails: {
        dateOfBirth: "${message['dateOfBirth']}",
        gender: "${message['gender']}"
      }
      }){
      token
      }
    }
    ''';
    Map response;
    try{
      response= await CustomGraphQLClient.instance.mutate(query);
      print(response);

      Bee bee = Bee()
        ..firstName = message['firstname']
        ..middleName = message['middlename'] ?? ''
        ..lastName = message['lastname'] ?? ''
        ..emailAddress = message['email'] ?? ''
        ..phoneNumber = message['number']
        ..verified = message['verified']
        ..gender = message['gender']
        ..active = false
        ..dpUrl = null;

      DataStore.me = bee;
       return latestViewModel..registered=true;
    }
    catch(e){
      print(e);
      return latestViewModel..registered = false..error=e.toString();
    }


    // Map response = await RequestMaker(endpoint: EndPoints.REGISTER, body: {
    //   'name': {
    //     'firstName': message['firstname'],
    //     'middleName': message['middlename'],
    //     'lastName': message['lastname']
    //   },
    //   'email': message['email'],
    //   'fcmToken': fcmToken,
    //   'phone': message['phonenumber'],
    //   'personalDetails': {
    //     'dateOfBirth': message['dateOfBirth'],
    //     'gender': message['gender']
    //   }
    // }).makeRequest();

    // print(response.containsValue('created'));
    // print('Null : ${latestViewModel == null}');
    //
    // if (response.containsKey('created')) {
    //   return (latestViewModel..registered = true);
    // } else
    //   return (latestViewModel..registered = false);
  }

  Future<RegistrationModel> requestOtp(Map<String, dynamic> message) async {

    String query='''
      mutation{
        sendOtp(input:{phone:"${message['phonenumber']}"}){
          phone
          otpGenerated
        }
       }
     ''';
    Map response;
    try{
      response= await CustomGraphQLClient.instance.mutate(query);
      print(response['sendOtp']['otpGenerated'].toString());
      if(response['sendOtp']['otpGenerated'])
        return latestViewModel..sent=true;
    }
    catch(e){
      print(e);
      return latestViewModel..sent=false;
    }
    return latestViewModel;

  }
}
