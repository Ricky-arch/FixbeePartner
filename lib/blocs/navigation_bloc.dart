import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/navigation_event.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationModel> {
  NavigationBloc(NavigationModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<NavigationModel> mapEventToViewModel(
      NavigationEvent event, Map<String, dynamic> message) async {
    if (event == NavigationEvent.onMessage) {
      return await onMessage(message);
    }
    if (event == NavigationEvent.onConfirmDeclineJob) {
      return await onConfirmDeclineJob(message);
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
    QuantityInfo{
      Quantity
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
    Map location = response['data']['Order']['Location'];
    Map service = response['data']['Order']['Service'];
    Map user = response['data']['Order']['User'];
    latestViewModel
      ..gotJob = true
      ..order.graphQLId = response['data']['Order']['ID']
      ..location.locationId = location['ID']
      ..location.locationName = location['Name']
      ..location.addressLine = location['Address']['Line1']
      ..location.googlePlaceId = location['GooglePlaceID']
      ..service.serviceId = service['ID']
      ..service.serviceName = service['Name']
      ..service.priceable = service['Pricing']['Priceable']
      ..service.basePrice = service['Pricing']['BasePrice']
      ..service.serviceCharge = service['Pricing']['ServiceCharge']
      ..service.taxPercent = service['Pricing']['TaxPercent']
      ..order.status = response['data']['Order']['Status']
      ..user.userId = user['ID']
      ..user.firstname = user['Name']['Firstname']
      ..user.middlename = user['Name']['Middlename']
      ..user.lastname = user['Name']['LastName']
      ..user.phoneNumber = user['Phone']['Number']
      ..user.profilePicUrl = user['DisplayPicture']['id']
      ..order.cashOnDelivery = response['data']['Order']['CashOnDelivery']
      ..order.orderId = response['data']['Order']['OrderId']
      ..order.slotted = response['data']['Order']['Slot']['Slotted']
      ..order.slot = response['data']['Order']['Slot']['At']
      ..order.quantity = response['data']['Order']['QuantityInfo']['Quantity'];

    return latestViewModel;
  }

  Future<NavigationModel> onConfirmDeclineJob(
      Map<String, dynamic> message) async {
    String orderId = message['orderId'];
    bool accept = message['Accept'];
    String query = '''mutation {
	    AnswerOrderRequest(_id:"$orderId", input: { Accept: $accept }){
		  ID
		  Location {
			  Name
			  GooglePlaceID
		  }
	  }
    }''';
    latestViewModel..order.otp=message['data']['Order']['OTP'];
    await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }
}
