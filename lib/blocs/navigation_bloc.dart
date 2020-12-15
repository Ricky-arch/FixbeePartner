import 'dart:async';
import 'dart:developer';
import 'package:background_location/background_location.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:geolocator/geolocator.dart';

import '../Constants.dart';
enum TimerStatus{TICKING, PAUSED, STOPPED}
class NavigationBloc extends Bloc<NavigationEvent, NavigationModel>
    with Trackable {
  NavigationBloc(NavigationModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<NavigationModel> mapEventToViewModel(
      NavigationEvent event, Map<String, dynamic> message) async {
    if (event == NavigationEvent.onMessage) {
      return await onMessage(message);
    }
    if (event == NavigationEvent.onConfirmJob) {
      return await onConfirmDeclineJob(message);
    }
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

  Future<NavigationModel> onConfirmDeclineJob(
      Map<String, dynamic> message) async {
    String orderId = message['orderId'];
    bool accept = message['Accept'];
    String query = '''mutation {
  AnswerOrderRequest(_id: "$orderId", input: { Accept: $accept }) {
  
  Status
    ID
    Slot{
      Slotted
      At
    }
    CashOnDelivery
    BasePrice
    ServiceCharge
    TaxCharge
    Discount
    Service{
      Name
      Pricing{
          BasePrice
          ServiceCharge
          TaxPercent
        }
    }
    Amount
    User{
    ID
      Name{
        Firstname
        Middlename
        Lastname
      }
      Phone{
        Number
      }
      
       DisplayPicture{
        id
      }
    }
    Timestamp
    OTP
    Amount
    Quantity
    Location {
      Name
      GooglePlaceID
      Address{
        Line1
        Landmark
      }
    }
  }
}

''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    print(response.toString() + "oooo");

    log(
        response['AnswerOrderRequest']['Location']['Address']['Lankmark']
            .toString(),
        name: "landmark");
    return latestViewModel
      ..order.orderId = response['AnswerOrderRequest']['ID']
      ..order.quantity = response['AnswerOrderRequest']['Quantity']
      ..order.orderAmount = response['AnswerOrderRequest']['Amount']
      ..order.orderBasePrice = response['AnswerOrderRequest']['BasePrice']
      ..order.orderServiceCharge =
          response['AnswerOrderRequest']['ServiceCharge']
      ..order.orderTaxCharge = response['AnswerOrderRequest']['TaxCharge']
      ..order.status = response['AnswerOrderRequest']['Status']
      ..location.googlePlaceId =
          response['AnswerOrderRequest']['Location']['GooglePlaceID']
      ..order.slotted = response['AnswerOrderRequest']['Slot']['Slotted']
      ..service.serviceName = response['AnswerOrderRequest']['Service']['Name']
      ..user.userId = response['AnswerOrderRequest']['User']['ID']
      ..user.firstname =
          response['AnswerOrderRequest']['User']['Name']['Firstname']
      ..user.middlename =
          response['AnswerOrderRequest']['User']['Name']['Middlename']
      ..user.lastname =
          response['AnswerOrderRequest']['User']['Name']['Lastname']
      ..user.phoneNumber =
          response['AnswerOrderRequest']['User']['Phone']['Number']
      ..user.profilePicUrl =
          '${EndPoints.DOCUMENT}?id=${response['AnswerOrderRequest']['User']['DisplayPicture']['id']}'
      ..location.addressLine =
          response['AnswerOrderRequest']['Location']['Address']['Line1']
      ..location.landmark =
          response['AnswerOrderRequest']['Location']['Address']['Landmark']
      ..order.timeStamp = response['AnswerOrderRequest']['Timestamp']
      ..order.price = response['AnswerOrderRequest']['Amount']
      ..order.basePrice =
          response['AnswerOrderRequest']['Service']['Pricing']['BasePrice']
      ..order.serviceCharge =
          response['AnswerOrderRequest']['Service']['Pricing']['ServiceCharge']
      ..order.taxPercent =
          response['AnswerOrderRequest']['Service']['Pricing']['TaxPercent']
      ..order.cashOnDelivery = response['AnswerOrderRequest']['CashOnDelivery']
      ..user.profilePicId =
          response['AnswerOrderRequest']['User']['DisplayPicture']['id'];
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
    if(testTimer==null)
    testTimer = Timer.periodic(Duration(seconds: timeOut), (timer) async {
      if(_timerStatus==TimerStatus.TICKING){
        print('TICK');

          try {
            location = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best);
            await updateLiveLocation(
                {'latitude': location.latitude, 'longitude': location.longitude});
          } catch (e) {
            location = null;
          }

      }

    });
  }
  pauseTimer(){
    _timerStatus = TimerStatus.PAUSED;
  }

  endTimer() {
    log("TIMER ENDED", name: "TS");
    _timerStatus = TimerStatus.STOPPED;
    testTimer.cancel();
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
    return latestViewModel;
  }

  unsubscribeToLocationUpdate() {
    timer.cancel();
    locationTimer.cancel();
  }
}
