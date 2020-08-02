import 'dart:developer';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../Constants.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationModel> {
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
    return latestViewModel;
  }

  Future<NavigationModel> onMessage(Map<String, dynamic> message) async {
    return await getInitialJobDetails(message['order_id']);
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
//   if(response.isNotEmpty)
//     print(response.toString()+"xxx");
//    Map location = response['Order']['Location'];
//    Map service = response['Order']['Service'];
//    Map user = response['Order']['User'];
//    latestViewModel
//      ..gotJob = true
//      ..order.graphQLId = response['Order']['ID']
//      ..location.locationId = location['ID']
//      ..location.locationName = location['Name']
//      ..location.addressLine = location['Address']['Line1']
//      ..location.googlePlaceId = location['GooglePlaceID']
//      ..service.serviceId = service['ID']
//      ..service.serviceName = service['Name']
//      ..service.priceable = service['Pricing']['Priceable']
//      ..service.basePrice = service['Pricing']['BasePrice']
//      ..service.serviceCharge = service['Pricing']['ServiceCharge']
//      ..service.taxPercent = service['Pricing']['TaxPercent']
//      ..order.status = response['Order']['Status']
//      ..user.userId = user['ID']
//      ..user.firstname = user['Name']['Firstname']
//      ..user.middlename = user['Name']['Middlename']
//      ..user.lastname = user['Name']['LastName']
//      ..user.phoneNumber = user['Phone']['Number']
//      ..user.profilePicUrl = user['DisplayPicture']['id']
//      ..order.cashOnDelivery = response['Order']['CashOnDelivery']
//      ..order.orderId = response['Order']['OrderId']
//      ..order.slotted = response['Order']['Slot']['Slotted']
//      ..order.slot = response['Order']['Slot']['At'];
//
    return latestViewModel;
  }

  Future<NavigationModel> onConfirmDeclineJob(
      Map<String, dynamic> message) async {
    String orderId = message['orderId'];
    bool accept = message['Accept'];
    String query = '''mutation {
  AnswerOrderRequest(_id: "$orderId", input: { Accept: $accept }) {
    ID
    Slot{
      Slotted
      At
    }
    Service{
      Name
    }
    Amount
    User{
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
    if (response['AnswerOrderRequest']['Slot']['Slotted']) {
      latestViewModel.order.slottedAt =
          response['AnswerOrderRequest']['Slot']['At'];
    }
    log(
        response['AnswerOrderRequest']['Location']['Address']['Lankmark']
            .toString(),
        name: "landmark");
    return latestViewModel
      ..order.orderId = response['AnswerOrderRequest']['ID']
      ..location.googlePlaceId =
          response['AnswerOrderRequest']['Location']['GooglePlaceID']
      ..order.slotted = response['AnswerOrderRequest']['Slot']['Slotted']
      ..service.serviceName = response['AnswerOrderRequest']['Service']['Name']
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
    ..user.profilePicId=response['AnswerOrderRequest']['User']['DisplayPicture']['id'];
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
}
