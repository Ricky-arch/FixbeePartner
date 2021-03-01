import 'dart:developer';
import 'package:fixbee_partner/blocs/history_bloc.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/ui/custom_widget/active_order_history.dart';
import 'package:fixbee_partner/ui/custom_widget/credit.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_date_picker.dart';
import 'package:fixbee_partner/ui/custom_widget/debit.dart';
import 'package:fixbee_partner/ui/custom_widget/past_order.dart';
import 'package:fixbee_partner/ui/custom_widget/transaction_card.dart';
import 'package:fixbee_partner/ui/custom_widget/transaction_detailed.dart';
import 'package:fixbee_partner/ui/custom_widget/transaction_type.dart';
import 'package:fixbee_partner/ui/screens/debit_info.dart';
import 'package:fixbee_partner/ui/screens/past_order_billing_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Constants.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryBloc _bloc;
  String start, end;
  String transactionType = 'Credit';
  List<Transactions> transactions = [];
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  DateTime now = DateTime.now();
  bool transactionCall = false;

  // Future getTransactions() async {
  //   _bloc.fire(HistoryEvent.getTransactions,
  //       message: {'start': start, 'end': end, 'type': transactionType},
  //       onHandled: (e, m) {
  //     transactions = [];
  //     setState(() {
  //       transactions = m.transactions;
  //     });
  //   });
  //   return transactions;
  // }

  @override
  void initState() {
    _bloc = HistoryBloc(HistoryModel());
    start = formatter.format(now);
    end = formatter.format(now);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _bloc.widget(onViewModelUpdated: (context, viewModel) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: PrimaryColors.backgroundcolorlight,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
//               pinned: true,
//                floating: false,
                titleSpacing: 0,
                backgroundColor: PrimaryColors.backgroundColor,
                elevation: 3,
                title: Container(
                  height: 32,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 12, 12, 0),
                    child: Text(
                      "HISTORY",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.white,
                            ),
                            insets: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5)),
                        tabs: [
                          Tab(
                            child: Text(
                              'TRANSACTIONS',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'PAST',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'IN-PROGRESS',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              SliverFillRemaining(
                  child: TabBarView(
                children: <Widget>[
                  Tab(
                      child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                      mini: false,
                      elevation: 5,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          transactionCall = true;
                        });
                      },
                    ),
                    body: Column(
                      children: [
                        Container(
                          color: PrimaryColors.backgroundColor,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TransactionType(
                                    setTransactionType: (value) {
                                      transactionCall = false;
                                      setState(() {
                                        transactionType = value;
                                      });
                                    },
                                  ),
                                  CustomDatePicker(
                                    title: 'START',
                                    setDate: (value) {
                                      transactionCall = false;
                                      setState(() {
                                        start = formatter.format(value);
                                      });
                                    },
                                  ),
                                  CustomDatePicker(
                                    title: 'END',
                                    setDate: (value) {
                                      transactionCall = false;
                                      setState(() {
                                        end = formatter.format(value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        (transactionCall)
                            ? FutureBuilder(
                                future: _bloc.getTransactions({
                                  'start': start,
                                  'end': end,
                                  'type': transactionType
                                }),
                                builder: (ctx, snapshot) {
                                  if (!snapshot.hasData)
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                        ),
                                        CustomCircularProgressIndicator()
                                      ],
                                    );
                                  else {
                                    if (snapshot.data.transactions.length == 0)
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                          ),
                                          Text(
                                            'No such transactions available as per filter...',
                                            style: TextStyle(
                                                color: PrimaryColors
                                                    .backgroundColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      );
                                    return Expanded(
                                      child: ListView(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snapshot
                                                  .data.transactions.length,
                                              itemBuilder: (ctx, index) {
                                                return TransactionCard(
                                                    transaction: snapshot.data
                                                        .transactions[index],
                                                    seeMore: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TransactionDetailed(
                                                                    transaction:
                                                                        snapshot
                                                                            .data
                                                                            .transactions[index],
                                                                  )));
                                                    });
                                              }),
                                        ],
                                      ),
                                    );
                                  }
                                })
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                  ),
                                  Text(
                                    'Enter appropriate filter...',
                                    style: TextStyle(
                                        color: PrimaryColors.backgroundColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              )
                      ],
                    ),
                  )),
                  Tab(
                    child: (true)
                        ? Container()
                        : FutureBuilder<HistoryModel>(
                            future: _bloc.fetchBasicPastOrderDetails(),
                            builder: (ctx, snapshot) {
                              if (!snapshot.hasData) {
                                return CustomCircularProgressIndicator();
                              } else {
                                log(snapshot.data.pastOrderPresent.toString(),
                                    name: "PastOrder");
                                return (snapshot.data.pastOrderPresent)
                                    ? ListView(
                                        children: [
                                          ListView.builder(
                                              itemCount: snapshot
                                                  .data.pastOrderList.length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                int index = snapshot.data
                                                        .pastOrderList.length -
                                                    i -
                                                    1;
                                                return PastOrder(
                                                  backGroundColor: Colors.white,
                                                  amount: snapshot
                                                      .data
                                                      .pastOrderList[index]
                                                      .totalAmount,
                                                  loading: snapshot.data
                                                          .loadingDetails &&
                                                      snapshot
                                                              .data
                                                              .pastOrderList[
                                                                  index]
                                                              .orderId ==
                                                          snapshot.data
                                                              .selectedOrderID,
                                                  serviceName: snapshot
                                                      .data
                                                      .pastOrderList[index]
                                                      .serviceName,
                                                  status: snapshot
                                                      .data
                                                      .pastOrderList[index]
                                                      .status,
                                                  timeStamp: snapshot
                                                      .data
                                                      .pastOrderList[index]
                                                      .timeStamp,
                                                  seeMore: () {
                                                    String orderID = snapshot
                                                        .data
                                                        .pastOrderList[index]
                                                        .orderId;
                                                    _bloc.fire(
                                                        HistoryEvent
                                                            .fetchCompletePastOrderInfo,
                                                        message: {
                                                          'orderID': orderID
                                                        }, onHandled: (e, m) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext context) => PastOrderBillingScreen(
                                                                  quantity: m
                                                                      .jobModel
                                                                      .quantity,
                                                                  orderAmount: m
                                                                      .jobModel
                                                                      .orderAmount,
                                                                  orderDiscount: m
                                                                      .jobModel
                                                                      .orderDiscount,
                                                                  orderBasePrice: m
                                                                      .jobModel
                                                                      .orderBasePrice,
                                                                  orderServiceCharge: m
                                                                      .jobModel
                                                                      .orderServiceCharge,
                                                                  orderTaxCharge: m
                                                                      .jobModel
                                                                      .orderTaxCharge,
                                                                  addOns: m
                                                                      .jobModel
                                                                      .addons,
                                                                  serviceName: m
                                                                      .jobModel
                                                                      .serviceName,
                                                                  totalAddonBasePrice: m
                                                                      .jobModel
                                                                      .totalAddonServiceCharge,
                                                                  totalAddonServiceCharge: m.jobModel.totalAddonBasePrice,
                                                                  amount: m.jobModel.totalAmount,
                                                                  status: m.jobModel.status,
                                                                  orderId: m.jobModel.orderId,
                                                                  cashOnDelivery: m.jobModel.cashOnDelivery,
                                                                  address: m.jobModel.addressLine,
                                                                  userName: m.jobModel.userName,
                                                                  serviceCharge: m.jobModel.serviceCharge,
                                                                  basePrice: m.jobModel.basePrice,
                                                                  taxPercent: m.jobModel.taxPercent,
                                                                  timeStamp: snapshot.data.pastOrderList[index].timeStamp)));
                                                    });
                                                  },
                                                );
                                              })
                                        ],
                                      )
                                    : Text('No Past Orders',
                                        style: TextStyle(color: Colors.black));
                              }
                            },
                          ),
                  ),
                  Tab(
                      child: FutureBuilder<HistoryModel>(
                          future: _bloc.fetchActiveOrder(),
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData)
                              return CustomCircularProgressIndicator();
                            else {
                              return (snapshot.data.isOrderActive)
                                  ? ActiveOrderHistory(
                                      serviceName:
                                          snapshot.data.orders.serviceName,
                                      seeMore: () {
                                        Route route = MaterialPageRoute(
                                            builder: (context) => WorkScreen(
                                                  orderModel:
                                                      snapshot.data.orders,
                                                ));
                                        Navigator.pushReplacement(
                                            context, route);
                                      },
                                      userName:
                                          snapshot.data.orders.user.firstname,
                                      status: snapshot.data.orders.status,
                                      timeStamp:
                                          DateTime.now().toLocal().toString(),
                                    )
                                  : Text('No orders in progress',
                                      style: TextStyle(color: Colors.black));
                            }
                          })),
                ],
              )),
            ],
          ),
        ),
      );
    }));
  }

  _showDebitDialogBox(DebitTransactions debit) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 12),
            child: DebitInfo(
              timeStamp: debit.timeStamp,
              amount: debit.amount,
              accountId: debit.accountID,
              debitOnOrder: debit.debitOnOrder,
              withDrawlAccountHolderName: debit.withDrawlAccountHolderName,
              withDrawlAccountNumber: debit.withDrawlAccountNumber,
              withDrawlTransactionId: debit.withDrawlTransactionId,
              orderId: debit.orderId,
            ),
          );
        });
  }
}
