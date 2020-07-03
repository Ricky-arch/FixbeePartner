import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationModel> {
  NavigationBloc(NavigationModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<NavigationModel> mapEventToViewModel(
      NavigationEvent event, Map<String, dynamic> message) async {
    if (event == NavigationEvent.gotJobNotificationID)
      return await getNotificationID();
    if (event == NavigationEvent.getJobNotification)
      return await getInitialJobDetails(message['ID']);

    return latestViewModel;
  }

  Future<NavigationModel> getNotificationID() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          return latestViewModel
            ..jobId = message['notification']['data']['id'].toString();
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onResume: (Map<String, dynamic> message) async {
          return latestViewModel
            ..jobId = message['notification']['data']['id'].toString();
        },
        onLaunch: (message) async {
          return latestViewModel
            ..jobId = message['notification']['data']['id'].toString();
        });
    return latestViewModel;
  }

  Future<NavigationModel> getInitialJobDetails(String id) async {
    String query = '''
   {
  Order(_id: "$id") {
    ID
    Location {
      ID
      Name
      Address {
        Line1
      }
      GooglePlaceID
    }
    Service {
      ID
      Name
      Pricing {
        Priceable
        BasePrice
        ServiceCharge
        TaxPercent
      }
    }
    Status
    User {
      ID
      Name {
        Firstname
        Middlename
        Lastname
      }
      Phone {
        Number
      }
    }
    CashOnDelivery
    OrderId
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    Map location= response['data']['Order']['Location'];
    Map service= response['data']['Order']['Service'];
    Map user=response['data']['Order']['User'];
    latestViewModel..order.graphQLId=response['data']['Order']['ID']
    ..location.locationId=location['ID']
    ..location.locationName=location['Name']
    ..location.addressLine=location['Address']['Line1']
    ..location.googlePlaceId=location['GooglePlaceID']
    ..service.serviceId=service['ID']
    ..service.serviceName=service['Name']
    ..service.priceable=service['Pricing']['Priceable']
    ..service.basePrice=service['Pricing']['BasePrice']
    ..service.serviceCharge=service['Pricing']['ServiceCharge']
    ..service.taxPercent=service['Pricing']['TaxPercent']
    ..order.status=response['data']['Order']['Status']
    ..user.userId=user['ID']
    ..user.firstname=user['Name']['Firstname']
    ..user.middlename=user['Name']['Middlename']
    ..user.lastname=user['Name']['LastName']
    ..user.phoneNumber=user['Phone']['Number']
    ..order.cashOnDelivery=response['data']['Order']['CashOnDelivery']
    ..order.orderId=response['data']['Order']['OrderId'];
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
