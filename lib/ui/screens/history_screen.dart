import 'dart:developer';
import 'package:fixbee_partner/blocs/history_bloc.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/ui/custom_widget/active_order_history.dart';
import 'package:fixbee_partner/ui/custom_widget/credit.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_date_picker.dart';
import 'package:fixbee_partner/ui/custom_widget/debit.dart';
import 'package:fixbee_partner/ui/custom_widget/paginated_list.dart';
import 'package:fixbee_partner/ui/custom_widget/past_order.dart';
import 'package:fixbee_partner/ui/custom_widget/past_order_screen.dart';
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
  final int limit = 5;
  var start, end;
  String transactionType = 'Credit';
  List<Transactions> transactions = [];
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  DateTime now = DateTime.now();
  bool transactionCall = false;
  ScrollController _scrollController = ScrollController();
  PaginatedListViewController<Orders> _controller;

  @override
  void initState() {
    _bloc = HistoryBloc(HistoryModel());
    start = formatter.format(now);
    end = formatter.format(now);
    _controller = PaginatedListViewController<Orders>(
        _bloc.fetchBasicPastOrderDetails, limit);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    _scrollController.dispose();
    _controller.dispose();
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
                backgroundColor: Theme.of(context).canvasColor,
                titleSpacing: 0,
                elevation: 3,
                title: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 12, 12, 0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Your  ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          TextSpan(
                            text: "History",
                            style: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
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
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'PAST',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'IN-PROGRESS',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
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
                    floatingActionButton: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: Theme.of(context).accentColor)),
                      child: FloatingActionButton(
                        mini: true,
                        elevation: 5,
                        backgroundColor: Colors.transparent,
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
                    ),
                    body: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
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
                                  if (snapshot.hasError) {
                                    return Expanded(
                                      child: Center(
                                        child: Text(
                                          snapshot.error.toString(),
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    );
                                  }
                                  if (!snapshot.hasData)
                                    return Expanded(
                                      child: Center(
                                          child:
                                              CustomCircularProgressIndicator()),
                                    );
                                  else {
                                    if (snapshot.data.transactions.length == 0)
                                      return Expanded(
                                        child: Center(
                                          child: Text(
                                            'No transactions available!',
                                            style: TextStyle(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      );
                                    return Expanded(
                                      child: ListView(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              padding:
                                                  EdgeInsets.only(bottom: 60),
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
                            : Expanded(
                                child: Center(
                                  child: Text(
                                    'Enter appropriate filter!',
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              )
                      ],
                    ),
                  )),
                  Tab(
                      //child: SizedBox(),
                      child: PastOrderScreen(
                    listOfOrders: _bloc.fetchBasicPastOrderDetails,
                  )),
                  Tab(
                      child: FutureBuilder<HistoryModel>(
                          future: _bloc.fetchActiveOrder(),
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData)
                              return Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.height,
                                  color: Theme.of(context).canvasColor,
                                  child: Center(
                                      child:
                                          CustomCircularProgressIndicator()));
                            else {
                              return (snapshot.hasError)
                                  ? Container(
                                      color: Theme.of(context).canvasColor,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.height,
                                      child: Center(
                                        child: Text(snapshot.error,
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    )
                                  : (snapshot.data.isOrderActive)
                                      ? Container(
                                          color: Theme.of(context).canvasColor,
                                          child: ActiveOrderHistory(
                                            serviceName: snapshot
                                                .data.orders.serviceName,
                                            seeMore: () {
                                              if (!snapshot.hasError) {
                                                Route route = MaterialPageRoute(
                                                    builder: (context) =>
                                                        WorkScreen(
                                                          orderModel: snapshot
                                                              .data.orders,
                                                        ));
                                                Navigator.push(context, route);
                                              }
                                            },
                                            userName: snapshot
                                                .data.orders.user.firstname,
                                            status: snapshot.data.orders.status,
                                            timeStamp: DateTime.now()
                                                .toLocal()
                                                .toString(),
                                          ),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width: MediaQuery.of(context)
                                              .size
                                              .height,
                                          color: Theme.of(context).canvasColor,
                                          child: Center(
                                            child: Text('No orders in progress',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                          ),
                                        );
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
}
