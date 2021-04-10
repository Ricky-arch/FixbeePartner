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
    String id = message['id'];
    int score = message['Score'];
    String review = message['Review'];

    String query = '''
    mutation{
  rateOrder(id:"$id", input:{score:$score, review:"$review"}){
    id
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
      receipt.serviceCharge =receiptMap['serviceCharge'];
      receipt.amount = receiptMap['amount'];
      print(response['receipt']['referenceId']+'IDDD');
      if (receiptMap['payment'] != null) {
        receipt.payment.amount = receiptMap['payment']['amount'];
        receipt.payment.status = receiptMap['payment']['status'];
        receipt.payment.amountRefunded =
            receiptMap['payment']['amount_refunded'].toString();
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
