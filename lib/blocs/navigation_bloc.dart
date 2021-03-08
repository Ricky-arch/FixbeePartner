import 'dart:async';
import 'dart:developer';
import 'package:background_location/background_location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:geolocator/geolocator.dart';

import '../Constants.dart';
import '../data_store.dart';

enum TimerStatus { TICKING, PAUSED, STOPPED }

class NavigationBloc extends Bloc<NavigationEvent, NavigationModel>
    with Trackable {
  NavigationBloc(NavigationModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<NavigationModel> mapEventToViewModel(
      NavigationEvent event, Map<String, dynamic> message) async {
    if (event == NavigationEvent.onMessage) {
      return await onMessage(message);
    }
    // if (event == NavigationEvent.onConfirmJob) {
    //   return await onConfirmDeclineJob(message);
    // }
    if (event == NavigationEvent.getServiceData) {
      return await getServiceData(message);
    }
    if (event == NavigationEvent.getUserData) {
      return await getUserData(message);
    }

    if (event == NavigationEvent.updateLiveLocation) {
      return await updateLiveLocation(message);
    }
    if (event == NavigationEvent.startTimer) {
      return startTimer();
    }
    if (event == NavigationEvent.endTimer) {
      return endTimer();
    }
    if (event == NavigationEvent.updateFcmTest) {
      return await updateFcmTest();
    }

    return latestViewModel;
  }

  Future<NavigationModel> onMessage(Map<String, dynamic> message) async {
    return await getInitialJobDetails(message['order_id']);
  }

  Future<NavigationModel> checkActiveOrderStatus(
      Map<String, dynamic> message) async {
    String id = message['orderID'];
    String query = '''{
  Order(_id:"$id"){
    Status
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    return latestViewModel..order.status = response['Order']['Status'];
  }

  Future<NavigationModel> getInitialJobDetails(String id) async {
    String query = '''
   {
  Order(_id: "$id") {_bloc.fire(NavigationEvent.updateFcmTest);
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
      DisplayPicture{
        filename
        id
      }
      Phone {
        Number
      }
    }
    CashOnDelivery
    OrderId
    Slot{
      Slotted
      At
    }
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);

    return latestViewModel;
  }

  Future<Orders> onConfirmDeclineJob(String orderId) async {
    String query = '''mutation{
  acceptOrder(id:"$orderId"){
    status
    otp
    mode
    user{
      phone
      fullName
      displayPicture
    }
    location{
      fullAddress
      placeId
    }
    service{
      name
      quantity
    }
  }
}


''';
    Map response;
    try {
      response = await CustomGraphQLClient.instance.mutate(query);
      Orders order = Orders();
      order
        ..id = orderId
        ..status = response['acceptOrder']['status']
        ..otp = response['acceptOrder']['otp']
        ..cashOnDelivery =
            response['acceptOrder']['mode'] == 'COD' ? true : false
        ..user.phoneNumber = response['acceptOrder']['user']['phone']
        ..user.firstname = response['acceptOrder']['user']['fullName']
        ..user.profilePicId = response['acceptOrder']['user']['displayPicture']
        ..address = response['acceptOrder']['location']['fullAddress']
        ..placeId = response['acceptOrder']['location']['placeId']
        ..serviceName = response['acceptOrder']['service']['name']
        ..quantity = response['acceptOrder']['service']['quantity'];
      return order;
    } catch (e) {
      return null;
    }
  }

  Future<NavigationModel> getServiceData(Map<String, dynamic> message) async {
    String id = message['id'];
    String query = '''{
  Service(_id:"$id"){
    ID
    Name
    Image{
      filename
      id
      mimetype
      encoding
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    print(response['Service']['Name'] + "serviceName");
    return latestViewModel
      ..service.serviceName = response['Service']['Name']
      ..service.serviceId = response['Service']['ID'];
  }

  Future<NavigationModel> getUserData(Map<String, dynamic> message) async {
    String query = '''''';

    return latestViewModel;
  }

  @override
  ViewModel setTrackingFlag(Event event, bool trackFlag, Map message) {
    if (event == NavigationEvent.onConfirmJob)
      latestViewModel..onJobConfirmed = trackFlag;

    return latestViewModel;
  }

  Future<NavigationModel> checkActiveService() async {
    String query = '''{
  Me{
    ... on Bee{
      Active
      Available
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    if (response['Me']['Active'] && !response['Me']["Available"])
      latestViewModel..isOrderActive = true;
    return latestViewModel;
  }

  Timer locationTimer, timer, testTimer;
  TimerStatus _timerStatus = TimerStatus.STOPPED;
  startTimer() {
    _timerStatus = TimerStatus.TICKING;
    log("TIMER STARTED", name: "TS");
    var timeOut = Constants.updateLocationTimeOut;

    Position location;
    if (testTimer == null)
      testTimer = Timer.periodic(Duration(seconds: timeOut), (timer) async {
        if (_timerStatus == TimerStatus.TICKING) {
          print('TICK');

          try {
            location = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best);
            await updateLiveLocation({
              'latitude': location.latitude,
              'longitude': location.longitude
            });
          } catch (e) {
            location = null;
          }
        }
      });
  }

  pauseTimer() {
    _timerStatus = TimerStatus.PAUSED;
  }

  endTimer() {
    log("TIMER ENDED", name: "TS");
    _timerStatus = TimerStatus.STOPPED;
    if (testTimer != null) testTimer.cancel();
  }

  Future<bool> getActiveStatus() async {
    String query = '''{
  Me{
    ...on Bee{
      Active
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    return response['Me']['Active'].toString() == 'true';
  }

  subscribeToLocationUpdate(Function(Position) onUpdateLocation) {
    locationTimer = Timer.periodic(
        Duration(seconds: Constants.updateLocationTimeOut), (timer) async {
      log("Location Updated", name: "LOCATIONNAV");
      Position location = await _getLocation();
      updateLiveLocation(
          {'latitude': location.latitude, 'longitude': location.longitude});
    });
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

  Future<NavigationModel> updateLiveLocation(
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

  unsubscribeToLocationUpdate() {
    timer.cancel();
    locationTimer.cancel();
  }

  Future<NavigationModel> updateFcmTest() async {
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
}
