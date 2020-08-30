import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/models/home_model.dart';
import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:flutter/material.dart';

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
    if (event == HistoryEvent.fetchPastOrders) return await fetchPastOrders();
    return latestViewModel;
  }

  @override
  HistoryModel setTrackingFlag(
      HistoryEvent event, bool trackFlag, Map message) {
    return latestViewModel;
  }

  fetchCreditTransactions() {}

  fetchDebitTransactions() {}

  Future<HistoryModel> fetchPastOrders() async {
    String query = '''
    {Me{
  ...on Bee{
    Orders{
      ID
      Amount
      Status
      Service{
        Name
        Pricing{
          BasePrice
          ServiceCharge
          TaxPercent
        }
      }
      Timestamp
      Location{
        Address{
          Line1
        }
      }
      CashOnDelivery
    }
  }
}}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List orders = response['Me']['Orders'];
    List<OrderModel> pastOrders = [];
    orders.forEach((order) {
      if (order != null) {
        OrderModel pastOrder = OrderModel();
        pastOrder.orderId = order['ID'];
        print(order['ID']);
        pastOrder.serviceName = order['Service']['Name'];
        pastOrder.status = order['Status'];
        print(order['Status']);
        pastOrder.totalAmount = order['Amount'];
//        pastOrder.userFirstname = order['User']['Name']['Firstname'];
//        pastOrder.userMiddlename = order['User']['Name']['Middlename'] ?? "";
//        pastOrder.userLastname = order['User']['Name']['Lastname'] ?? "";
        pastOrder.timeStamp = order['Timestamp'];
        pastOrder.addressLine=order["Location"]['Address']['Line1'];
        pastOrder.basePrice=order['Service']['Pricing']['BasePrice'];
        pastOrder.taxPercent=order['Service']['Pricing']['TaxPercent'];
        pastOrder.serviceCharge=order['Service']['Pricing']['ServiceCharge'];
        pastOrder.cashOnDelivery=order['CashOnDelivery'];
        print(order['CashOnDelivery'].toString());
        pastOrders.add(pastOrder);
      }
    });
    return latestViewModel..pastOrderList = pastOrders;
  }
}
