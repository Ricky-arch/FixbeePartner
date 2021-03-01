import 'dart:developer';

import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/models/orders_model.dart';
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
    if (event == HistoryEvent.fetchActiveOrder) return await fetchActiveOrder();
    if (event == HistoryEvent.fetchBasicPastOrderDetails)
      return await fetchBasicPastOrderDetails();
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
      order.quantity = activeOrder['service']['quantity'];
      order.placeId = activeOrder['location']['placeId'];
      order.serviceName = activeOrder['service']['name'];
      order.user.firstname = activeOrder['user']['fullName'];
      order.user.phoneNumber = activeOrder['user']['phone'];
      order.user.profilePicId = activeOrder['user']['displayPicture'];
      order.status = activeOrder['status'];
      order.address = activeOrder['location']['fullAddress'];
      order.otp=activeOrder['otp'];
      order.cashOnDelivery = activeOrder['mode'] == "COD" ? true : false;
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

  Future<HistoryModel> fetchBasicPastOrderDetails() async {
    String query = '''{Me{
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
    Map response = await CustomGraphQLClient.instance.query(query);
    List orders = response['Me']['Orders'];
    if (orders.isEmpty || orders.length == 0) {
      if (orders == null) return latestViewModel..pastOrderPresent = false;
    }
    List<OrderModel> pastOrders = [];
    orders.forEach((order) {
      if (order != null && order['Service'] != null) {
        OrderModel pastOrder = OrderModel();
        pastOrder.orderId = order['ID'];
        pastOrder.serviceName = order['Service']['Name'];
        pastOrder.status = order['Status'];
        pastOrder.totalAmount = order['Amount'];
        pastOrder.timeStamp = order['Timestamp'];
        pastOrders.add(pastOrder);
      }
    });
    return latestViewModel
      ..pastOrderList = pastOrders
      ..pastOrderPresent = true;
  }

  Future<HistoryModel> fetchCompletePastOrderInfo(
      Map<String, dynamic> message) async {
    String orderID = message['orderID'];
    String query = '''{
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
    BasePrice
    ServiceCharge
    TaxCharge
    Discount
    Status
    Quantity
    Addons {
      Quantity
      BasePrice
      ServiceCharge
      TaxCharge
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
    Map response = await CustomGraphQLClient.instance.query(query);
    OrderModel order = OrderModel();
    order.orderId = response['Order']['ID'];
    order.totalAmount = response['Order']['Amount'];
    order.status = response['Order']['Status'];
    order.serviceName = response['Order']['Service']['Name'];
    order.orderAmount = response['Order']['Amount'];
    order.orderBasePrice = response['Order']['BasePrice'];
    order.orderServiceCharge = response['Order']['ServiceCharge'];
    order.orderDiscount = response['Order']['Discount'];
    order.orderTaxCharge = response['Order']['TaxCharge'];
    order.basePrice = response['Order']['Service']['Pricing']['BasePrice'];
    order.serviceCharge =
        response['Order']['Service']['Pricing']['ServiceCharge'];
    order.taxPercent = response['Order']['Service']['Pricing']['TaxPercent'];
    order.timeStamp = response['Order']['TimeStamp'];
    order.cashOnDelivery = response['Order']['CashOnDelivery'];
    order.addressLine = response['Order']['Location']['Address']['Line1'];
    order.quantity = response['Order']['Quantity'];
    order.userName = getUserName(
        response['Order']['User']['Name']['Firstname'],
        response['Order']['User']['Name']['Middlename'],
        response['Order']['User']['Name']['Lastname']);
    order.addons = [];
    int b = 0, s = 0;
    List addons = response['Order']['Addons'];
    for (Map addon in addons) {
      Service service = Service()
        ..serviceName = addon['Service']['Name']
        ..basePrice = addon['Service']['Pricing']['BasePrice']
        ..serviceCharge = addon['Service']['Pricing']['ServiceCharge']
        ..taxPercent = addon['Service']['Pricing']['TaxPercent']
        ..addOnBasePrice = addon['BasePrice']
        ..addOnServiceCharge = addon['ServiceCharge']
        ..addOnTaxCharge = addon['TaxCharge']
        ..quantity = addon['Quantity']
        ..amount = addon['Amount'];
      b = b + addon['BasePrice'];
      s = s + addon['ServiceCharge'];
      order.addons.add(service);
    }
    log(order.userName, name: "NAME");
    return latestViewModel
      ..jobModel = order
      ..jobModel.totalAddonBasePrice = b
      ..jobModel.totalAddonServiceCharge = s;
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
    try {
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
      print(list.length.toString() + 'LIST');
      return latestViewModel..transactions = list;
    } catch (e) {
      print(e);
    }
    return latestViewModel;
  }
}
