import 'dart:developer';

import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/billing_rating_model.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:flutter/material.dart';

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
    if (event == HistoryEvent.fetchActiveOrder) return await fetchActiveOrder();

    if (event == HistoryEvent.fetchCompletePastOrderInfo)
      return await fetchCompletePastOrderInfo(message);
    if (event == HistoryEvent.getTransactions)
      return await getTransactions(message);
    return latestViewModel;
  }

  @override
  HistoryModel setTrackingFlag(
      HistoryEvent event, bool trackFlag, Map message) {
    if (event == HistoryEvent.fetchCompletePastOrderInfo) {
      String orderID = message['orderID'];
      latestViewModel
        ..loadingDetails = trackFlag
        ..selectedOrderID = orderID;
    }
    return latestViewModel;
  }

  Future<HistoryModel> fetchCreditTransactions() async {
    String query = '''
    {
  Me {
    ... on Bee {
      Wallet {
        Transactions {
          ... on Credit {
            Amount
            TimeStamp
            Notes
          }
        }
      }
    }
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List<CreditTransactions> credits = [];
    List fetchedCredits = response['Me']['Wallet']['Transactions'];
    log("CALLED", name: "CREDIT");
    if (fetchedCredits.isEmpty || fetchedCredits.length == 0) {
      if (fetchedCredits == null)
        return latestViewModel..isCreditPresent = false;
    }
    fetchedCredits.forEach((credit) {
      if (credit.isNotEmpty && credit != null) {
        CreditTransactions cred = CreditTransactions();
        cred.amount = credit['Amount'];
        cred.timeStamp = credit['TimeStamp'];
        Map notes = credit['Notes'];
        if (notes.containsKey('PaymentId'))
          cred.notes = credit['Notes']['PaymentId'];
        else {
          cred.notes = credit['Notes']['OrderId'];
          cred.creditOnOrder = true;
        }
        credits.add(cred);
      }
    });
    return latestViewModel
      ..credits = credits
      ..isCreditPresent = true;
  }

  Future<HistoryModel> fetchDebitTransactions() async {
    String query = '''
    {
  Me {
    ... on Bee {
      ID
      Wallet {
        Transactions {
          ... on Debit {
            Amount
            Notes
            TimeStamp
            To {
              AccountNumber
              AccountHolderName
              ID
            }
          }
        }
      }
    }
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List<DebitTransactions> debits = [];
    List fetchedDebits = response['Me']['Wallet']['Transactions'];
    if (fetchedDebits.isEmpty || fetchedDebits.length == 0) {
      if (fetchedDebits == null) return latestViewModel..isDebitPresent = false;
    }
    fetchedDebits.forEach((debit) {
      if (debit.isNotEmpty && debit != null) {
        DebitTransactions deb = DebitTransactions();
        deb.amount = debit['Amount'];
        deb.timeStamp = debit['TimeStamp'];
        Map notes = debit['Notes'];
        if (notes.containsKey('TransactionID')) {
          deb.withDrawlTransactionId = notes['TransactionID'];

          if (debit['To'] != null) {
            deb.withDrawlAccountNumber = debit['To']['AccountNumber'];
            deb.accountID = debit['To']['ID'];
            deb.withDrawlAccountHolderName = debit['To']['AccountHolderName'];
          } else {
            deb.accountID = "Account Details Unavailable";
            deb.withDrawlAccountNumber = "Account Details Unavailable";
            deb.withDrawlAccountHolderName = "Account Details Unavailable";
          }
        } else {
          deb.debitOnOrder = true;
          deb.orderId = notes['OrderId'];
        }
        debits.add(deb);
      }
    });
    return latestViewModel
      ..debits = debits
      ..isDebitPresent = true;
  }

  Future<HistoryModel> fetchActiveOrder() async {
    String query = '''{
  activeOrder{
    id
    otp
    user{
      fullName
      phone
      displayPicture
    }
    status
    service{
      name
      quantity
    }
    location{
      fullAddress
      placeId
    }
    mode
    addons{
      name
      quantity
    }
  
  }
}
''';
    try {
      Map response = await CustomGraphQLClient.instance.query(query);
      if (response['activeOrder'] == null)
        return latestViewModel..isOrderActive = false;
      Orders order = Orders();
      Map activeOrder = response['activeOrder'];
      latestViewModel.isOrderActive = true;
      order.id = activeOrder['id'];
      order.quantity = activeOrder['service']['quantity'];
      order.placeId = activeOrder['location']['placeId'];
      order.serviceName = activeOrder['service']['name'];
      order.user.firstname = activeOrder['user']['fullName'];
      order.user.phoneNumber = activeOrder['user']['phone'];
      order.user.profilePicId = activeOrder['user']['displayPicture'];
      order.status = activeOrder['status'];
      order.address = activeOrder['location']['fullAddress'];
      order.otp = activeOrder['otp'];
      order.cashOnDelivery = activeOrder['mode'] == "cod" ? true : false;
      List<Service> addOns = [];
      if (activeOrder['addons'].length != 0) {
        for (Map addon in activeOrder['addons']) {
          Service s = Service();
          s.serviceName = addon['name'];
          s.quantity = addon['quantity'];
          addOns.add(s);
        }
      }
      order.addOns = addOns;
      return latestViewModel..orders = order;
    } catch (e) {
      print(e);
      return latestViewModel;
    }
  }

  Future<List<Orders>> fetchBasicPastOrderDetails(int skip) async {



    String query = '''{
  orders (skip:$skip, limit:10){
   
    id
    user {
      fullName
    }
    status
    createdAt
    service {
      name
      quantity
      pricing {
        basePrice
        serviceCharge
        taxPercent
      }
    }
    mode
    addons {      
      name
      quantity
      priceable
      pricing {
        basePrice
        serviceCharge
        taxPercent
        quantifiable

      }
    }
  }
}
''';
    Map response = await CustomGraphQLClient.instance.query(query);

    List orders = response['orders'];

    List<Orders> pastOrders = [];
    orders.forEach((order) {
      if (order != null && order['service'] != null) {
        Orders pastOrder = Orders();
        pastOrder.id = order['id'];
        pastOrder.serviceName = order['service']['name'];
        pastOrder.status = order['status'];
        pastOrder.amount = 00;
        pastOrder.cashOnDelivery = order['mode'] == 'COD' ? true : false;
        pastOrder.timeStamp = order['createdAt'];
        pastOrders.add(pastOrder);
      }
    });
    return pastOrders;
  }

  Future<HistoryModel> fetchCompletePastOrderInfo(
      Map<String, dynamic> message) async {
    String orderID = message['id'];
    String query = '''{
  receipt(id:"$orderID") {
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
      phone
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
      receipt.userName = receiptMap['client']['name'];
      receipt.serviceCharge = receiptMap['serviceCharge'];
      receipt.amount = receiptMap['amount'];
      if (receiptMap['payment'] != null) {
        receipt.payment.amount = receiptMap['payment']['amount'];
        receipt.payment.status = receiptMap['payment']['status'];
        receipt.payment.amountRefunded =
            receiptMap['payment']['amount_refunded'];
        receipt.payment.refundStatus = receiptMap['payment']['refund_status'];
        receipt.payment.method = receiptMap['payment']['method'];
        receipt.payment.captured = receiptMap['payment']['captured'];
      } else
        receipt.payment = null;
      List services = receiptMap['services'];
      List<ServiceOptionModel> serviceList = [];
      services.forEach((service) {
        ServiceOptionModel s = ServiceOptionModel();
        s.serviceName = service['description'];
        s.amount = service['amount'];
        serviceList.add(s);
      });
      receipt.services = serviceList;
      return latestViewModel..receipt = receipt;
    } catch (e) {
      print(e);
    }
    return latestViewModel;
  }

  String getUserName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  Future<HistoryModel> getTransactions(Map<String, dynamic> message) async {
    String start = message['start'];
    String end = message['end'];
    String type = message['type'].toString().toLowerCase();
    if (type == 'all') type = '';
    String query = '''{
  transactions(
    startDate:"$start"
    endDate:"$end"
    column: "$type"
  ) {
    column
    amount
    currency
    referenceId
    faId
    payment {
      amount
      currency
      status
      method
      refund_status
      amount_refunded
      captured
    }
    payout {
      amount
      currency
      status
      mode
      utr
    }
    paymentId
    payoutId
    createdAt
  } 
}
''';

    latestViewModel.transactions = [];
    Map response = await CustomGraphQLClient.instance.query(query);
    List listOfTransaction = response['transactions'];
    List<Transactions> list = [];
    listOfTransaction.forEach((transaction) {
      Transactions t = Transactions();
      t.column = transaction['column'];
      t.amount = transaction['amount'];
      t.currency = transaction['currency'];
      t.referenceId = transaction['referenceId'];
      t.paymentId = transaction['paymentId'];
      t.payoutId = transaction['payoutId'];
      t.createdAt = transaction['createdAt'];
      t.fundAccountID = transaction['faId'];
      print(t.toString() + 'CHECK 1');
      if (transaction['payout'] != null) {
        t.payout.amount = transaction['payout']['amount'];
        t.payout.currency = transaction['payout']['currency'];
        t.payout.status = transaction['payout']['status'];
        t.payout.mode = transaction['payout']['mode'];
        t.payout.utr = transaction['payout']['utr'];
      }
      if (transaction['payment'] != null) {
        t.payment.amount = transaction['payment']['amount'];
        t.payment.currency = transaction['payment']['currency'];
        t.payment.status = transaction['payment']['status'];
        t.payment.method = transaction['payment']['method'];
        t.payment.refundStatus = transaction['payment']['refund_status'];
        t.payment.amountRefunded = transaction['payment']['amount_refunded'];
        t.payment.captured = transaction['payment']['captured'];
      }
      list.add(t);
    });
    return latestViewModel..transactions = list;
    // } catch (e) {
    //   print(e+'ERROR AT CREDIT');
    // }
    // return latestViewModel;
  }
}
