import 'dart:developer';

import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../Constants.dart';
import '../bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryModel>
    with Trackable<HistoryEvent, HistoryModel> {
  HistoryBloc(HistoryModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<HistoryModel> mapEventToViewModel(
      HistoryEvent event, Map<String, dynamic> message) async {
    if (event == HistoryEvent.fetchCreditTransactions)
      return await fetchCreditTransactions();
    if (event == HistoryEvent.fetchDebitTransactions)
      return await fetchDebitTransactions();
    if (event == HistoryEvent.fetchActiveOrder)
      return await fetchActiveOrder();
    if(event==HistoryEvent.fetchBasicPastOrderDetails)
      return await fetchBasicPastOrderDetails();
    if(event==HistoryEvent.fetchCompletePastOrderInfo)
      return await fetchCompletePastOrderInfo(message);
    return latestViewModel;
  }

  @override
  HistoryModel setTrackingFlag(
      HistoryEvent event, bool trackFlag, Map message) {

    if(event==HistoryEvent.fetchCompletePastOrderInfo){
      String orderID=message['orderID'];
     latestViewModel..loadingDetails=trackFlag..selectedOrderID=orderID;

    }
    return latestViewModel;
  }

  fetchCreditTransactions() {}

  fetchDebitTransactions() {}




  Future<HistoryModel> fetchActiveOrder() async{
    String query = '''{
  Me {
    ... on Bee {
      ActiveOrder {
      Status
        ID
        Location {
          ID
          Name
          Address {
            Line1
            Landmark
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
        Timestamp
        Addons {
          Service {
            Name
            Pricing {
              BasePrice
              ServiceCharge
              TaxPercent
            }
          }
          Amount
        }
        Amount
        User {
          ID
          Name {
            Firstname
            Middlename
            Lastname
          }
          DisplayPicture {
            filename
            id
          }
          Phone {
            Number
          }
        }
        CashOnDelivery
        OrderId
        Slot {
          Slotted
          At
        }
      }
    }
  }
}
''';
    Map response = await CustomGraphQLClient.instance.query(query);
    if(response['Me']['ActiveOrder']== null)
      return latestViewModel..isOrderActive=false;
    return latestViewModel
      ..isOrderActive=true
      ..order.orderId = response['Me']['ActiveOrder']['ID']
      ..location.googlePlaceId =
      response['Me']['ActiveOrder']['Location']['GooglePlaceID']
      ..order.slotted = response['Me']['ActiveOrder']['Slot']['Slotted']
      ..service.serviceName = response['Me']['ActiveOrder']['Service']['Name']
      ..user.userId= response['Me']['ActiveOrder']['User']['ID']
      ..user.firstname =
      response['Me']['ActiveOrder']['User']['Name']['Firstname']
      ..user.middlename =
      response['Me']['ActiveOrder']['User']['Name']['Middlename']
      ..user.lastname =
      response['Me']['ActiveOrder']['User']['Name']['Lastname']
      ..user.phoneNumber =
      response['Me']['ActiveOrder']['User']['Phone']['Number']
      ..user.profilePicUrl =
          '${EndPoints.DOCUMENT}?id=${response['Me']['ActiveOrder']['User']['DisplayPicture']['id']}'
      ..location.addressLine =
      response['Me']['ActiveOrder']['Location']['Address']['Line1']
      ..location.landmark =
      response['Me']['ActiveOrder']['Location']['Address']['Landmark']
      ..order.timeStamp = response['Me']['ActiveOrder']['Timestamp']
      ..order.price = response['Me']['ActiveOrder']['Amount']
      ..order.basePrice =
      response['Me']['ActiveOrder']['Service']['Pricing']['BasePrice']
      ..order.serviceCharge =
      response['Me']['ActiveOrder']['Service']['Pricing']['ServiceCharge']
      ..order.taxPercent =
      response['Me']['ActiveOrder']['Service']['Pricing']['TaxPercent']
      ..order.cashOnDelivery = response['Me']['ActiveOrder']['CashOnDelivery']
      ..user.profilePicId =
      response['Me']['ActiveOrder']['User']['DisplayPicture']['id']
      ..order.status=response['Me']['ActiveOrder']["Status"];
  }

 Future<HistoryModel> fetchBasicPastOrderDetails() async{
    String query='''{Me{
  ...on Bee{
    Orders{
      ID
      Amount
      Service{
        Name
      }
      Status
      Timestamp
    }
  }
}}''';
    Map response= await CustomGraphQLClient.instance.query(query);
    List orders = response['Me']['Orders'];
    if(orders.isEmpty || orders.length==0 ){
      if(orders==null)
        return latestViewModel..pastOrderPresent=false;
    }
    List<OrderModel> pastOrders = [];
    orders.forEach((order) {
      if (order != null && order['Service']!=null ) {
        OrderModel pastOrder = OrderModel();
        pastOrder.orderId = order['ID'];
        pastOrder.serviceName = order['Service']['Name'];
        pastOrder.status = order['Status'];
        pastOrder.totalAmount = order['Amount'];
        pastOrder.timeStamp = order['Timestamp'];
        pastOrders.add(pastOrder);
      }
    });
    return latestViewModel..pastOrderList = pastOrders..pastOrderPresent=true;
 }

  Future<HistoryModel> fetchCompletePastOrderInfo(Map<String, dynamic> message) async{
    String orderID= message['orderID'];
    String query='''{
  Order(_id: "$orderID") {
    Quantity
    ID
    User{
      Name{
        Firstname
        Middlename
        Lastname
      }
    }
    Location{
      Address{
        Line1
      }
    }
    Amount
    Status
    Quantity
    Addons {
      Service {
        Name
        Pricing {
          BasePrice
          ServiceCharge
          TaxPercent
        }
      }
      Amount
    }
    Service {
      Name
      Pricing {
        BasePrice
        ServiceCharge
        TaxPercent
      }
    }
    Timestamp
    Location {
      Address {
        Line1
      }
    }
    CashOnDelivery
  }
}
''';
    Map response= await CustomGraphQLClient.instance.query(query);
    OrderModel order= OrderModel();
    order.orderId=response['Order']['ID'];
    order.totalAmount=response['Order']['Amount'];
    order.status=response['Order']['Status'];
    order.serviceName=response['Order']['Service']['Name'];
    order.basePrice=response['Order']['Service']['Pricing']['BasePrice'];
    order.serviceCharge=response['Order']['Service']['Pricing']['ServiceCharge'];
    order.taxPercent=response['Order']['Service']['Pricing']['TaxPercent'];
    order.timeStamp=response['Order']['TimeStamp'];
    order.cashOnDelivery=response['Order']['CashOnDelivery'];
    order.addressLine=response['Order']['Location']['Address']['Line1'];
    order.quantity=response['Order']['Quantity'];
    order.userFirstname=getUserName(response['Order']['User']['Name']['Firstname'], response['Order']['User']['Name']['Middlename'], response['Order']['User']['Name']['Lastname']);
    order.addons=[];
    List addons = response['Order']['Addons'];
    for (Map addon in addons) {
      Service service = Service()
        ..serviceName = addon['Service']['Name']
        ..basePrice = addon['Service']['Pricing']['BasePrice']
        ..serviceCharge = addon['Service']['Pricing']['ServiceCharge']
        ..taxPercent = addon['Service']['Pricing']['TaxPercent']
        ..amount=addon['Amount'];
      order.addons.add(service);
    }
    log(order.userFirstname, name:"NAME");
    return latestViewModel..jobModel=order;
  }

  String getUserName(String first, middle, last){
    String name=first;
    if(middle!="")
      name=name+" "+middle;
    if(last!="")
      name=name+" "+last;
    return name;
  }
}
