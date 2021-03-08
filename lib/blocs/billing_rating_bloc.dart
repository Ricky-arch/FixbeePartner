import 'dart:developer';

import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/billing_rating_event.dart';
import 'package:fixbee_partner/models/billing_rating_model.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../bloc.dart';

class BillingRatingBloc extends Bloc<BillingRatingEvent, BillingRatingModel>
    with Trackable<BillingRatingEvent, BillingRatingModel> {
  BillingRatingBloc(BillingRatingModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<BillingRatingModel> mapEventToViewModel(
      BillingRatingEvent event, Map<String, dynamic> message) async {
    if (event == BillingRatingEvent.addRatingEvent)
      return await addRating(message);
    if (event == BillingRatingEvent.fetchOderBillDetails)
      return await fetchOderBillDetails(message);
    return latestViewModel;
  }

  Future<BillingRatingModel> addRating(Map<String, dynamic> message) async {
    String accountID = message['accountID'];
    int score = message['Score'];
    String review = message['Review'];

    String query = '''
    mutation{
  AddRating(input:{AccountId:"$accountID", Score:$score, Remark:"$review"}){
    Score
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  Future<BillingRatingModel> fetchOderBillDetails(
      Map<String, dynamic> message) async {
    String query = '''
    {
  receipt (id:"${message['id']}"){
    referenceId
    amount
    serviceCharge
    tax
    currency
    payment {
      amount
      currency
      status
      method
      refund_status
      amount_refunded
      captured
    }
    client {
      name
    
    }
    services {
      description
      amount
      tax
    }
  }
}
    ''';
    try {
      Map response = await CustomGraphQLClient.instance.query(query);
      Map receiptMap = response['receipt'];
      Receipt receipt = Receipt();
      receipt.referenceId = receiptMap['referenceId'];
      receipt.userName=receiptMap['client']['name'];
      receipt.amount = receiptMap['amount'];
      if (receiptMap['payment'] != null) {
        receipt.payment.amount = receiptMap['payment']['amount'];
        receipt.payment.status = receiptMap['payment']['status'];
        receipt.payment.amountRefunded =
            receiptMap['payment']['amount_refunded'];
        receipt.payment.refundStatus = receiptMap['payment']['refund_status'];
        receipt.payment.method=receiptMap['payment']['method'];
        receipt.payment.captured = receiptMap['payment']['captured'];
      } else
        receipt.payment = null;
      List services= receiptMap['services'];
      List<ServiceOptionModel> serviceList=[];
      services.forEach((service) {
        ServiceOptionModel s= ServiceOptionModel();
        s.serviceName=service['description'];
        s.amount=service['amount'];
        serviceList.add(s);
      });
      receipt.services=serviceList;
      return latestViewModel..receipt=receipt;
    } catch (e) {}
    return latestViewModel;
//     String orderID = message['orderID'];
//     String query = '''{
//   Order(_id: "$orderID") {
//     Quantity
//
//     ID
//     User{
//       Name{
//         Firstname
//         Middlename
//         Lastname
//       }
//     }
//     Location{
//       Address{
//         Line1
//       }
//     }
//     Amount
//     BasePrice
//     ServiceCharge
//     TaxCharge
//     Discount
//     Status
//     Quantity
//     Addons {
//       Quantity
//       BasePrice
//       ServiceCharge
//       TaxCharge
//       Service {
//         Name
//         Pricing {
//           BasePrice
//           ServiceCharge
//           TaxPercent
//         }
//       }
//       Amount
//     }
//     Service {
//       Name
//       Pricing {
//         BasePrice
//         ServiceCharge
//         TaxPercent
//       }
//     }
//     Timestamp
//     Location {
//       Address {
//         Line1
//       }
//     }
//     CashOnDelivery
//   }
// }
// ''';
//     Map response = await CustomGraphQLClient.instance.query(query);
//     OrderModel order = OrderModel();
//     order.orderId = response['Order']['ID'];
//     order.totalAmount = response['Order']['Amount'];
//     order.status = response['Order']['Status'];
//     order.serviceName = response['Order']['Service']['Name'];
//     order.orderAmount = response['Order']['Amount'];
//     order.orderBasePrice = response['Order']['BasePrice'];
//     order.orderServiceCharge = response['Order']['ServiceCharge'];
//     order.orderDiscount = response['Order']['Discount'];
//     order.orderTaxCharge = response['Order']['TaxCharge'];
//
//     order.basePrice = response['Order']['Service']['Pricing']['BasePrice'];
//     order.serviceCharge =
//         response['Order']['Service']['Pricing']['ServiceCharge'];
//     order.taxPercent = response['Order']['Service']['Pricing']['TaxPercent'];
//     order.timeStamp = response['Order']['Timestamp'];
//     order.cashOnDelivery = response['Order']['CashOnDelivery'];
//     order.addressLine = response['Order']['Location']['Address']['Line1'];
//     order.quantity = response['Order']['Quantity'];
//     order.userName = getUserName(
//         response['Order']['User']['Name']['Firstname'],
//         response['Order']['User']['Name']['Middlename'],
//         response['Order']['User']['Name']['Lastname']);
//     order.addons = [];
//     List addons = response['Order']['Addons'];
//     int b=0,s=0;
//     for (Map addon in addons) {
//
//       Service service = Service()
//         ..serviceName = addon['Service']['Name']
//         ..basePrice = addon['Service']['Pricing']['BasePrice']
//         ..serviceCharge = addon['Service']['Pricing']['ServiceCharge']
//         ..taxPercent = addon['Service']['Pricing']['TaxPercent']
//         ..addOnBasePrice = addon['BasePrice']
//         ..addOnServiceCharge = addon['ServiceCharge']
//         ..addOnTaxCharge = addon['TaxCharge']
//         ..quantity = addon['Quantity']
//         ..amount = addon['Amount'];
//       b=b+addon['BasePrice'];
//       s=s+addon['ServiceCharge'];
//       order.addons.add(service);
//     }
//     log(order.userName, name: "NAME");
//     return latestViewModel..orderModel = order..orderModel.totalAddonBasePrice=b..orderModel.totalAddonServiceCharge=s;
  }

  String getUserName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  @override
  BillingRatingModel setTrackingFlag(
      BillingRatingEvent event, bool trackFlag, Map message) {
    if (event == BillingRatingEvent.fetchOderBillDetails)
      latestViewModel.whileFetchingBillDetails = trackFlag;
    return latestViewModel;
  }
}
