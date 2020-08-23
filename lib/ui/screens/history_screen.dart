import 'package:fixbee_partner/blocs/history_bloc.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/ui/custom_widget/credit.dart';
import 'package:fixbee_partner/ui/custom_widget/past_order.dart';
import 'package:fixbee_partner/utils/dummy_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryBloc _bloc;
  @override
  void initState() {
    _bloc = HistoryBloc(HistoryModel());
    _bloc.fire(HistoryEvent.fetchPastOrders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _bloc.widget(onViewModelUpdated: (context, viewModel) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                titleSpacing: 0,
                backgroundColor: PrimaryColors.backgroundColor,
                elevation: 3,
                title: Container(
                  height: 40,
                  color: PrimaryColors.backgroundColor,
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
                  preferredSize: Size.fromHeight(40),
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
                              'CREDIT',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'DEBIT',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'PAST',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'REJECTED',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
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
                    child: ListView(children: [
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: DummyData.transactionsCredit.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Credit(
                              amount: DummyData.transactionsCredit[index]
                                  ['Amount'],
                              date: DummyData.transactionsCredit[index]
                                  ['TimeStamp'],
                            );
                          }),
                    ]),
                  ),
                  Tab(
                    child:
                        Text('REJECTED', style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                      child: ListView.builder(
                          itemCount: viewModel.pastOrderList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return PastOrder(
                              amount:
                                  viewModel.pastOrderList[index].totalAmount,
                              serviceName:
                                  viewModel.pastOrderList[index].serviceName,
                              status: viewModel.pastOrderList[index].status,
                              userName: viewModel
                                      .pastOrderList[index].userFirstname +
                                  " " +
                                  viewModel
                                      .pastOrderList[index].userMiddlename +
                                  " " +
                                  viewModel.pastOrderList[index].userLastname,
                              timeStamp:
                                  viewModel.pastOrderList[index].timeStamp,
                            );
                          })),
                  Tab(
                    child:
                        Text('REJECTED', style: TextStyle(color: Colors.black)),
                  ),
                ],
              )),
            ],
          ),
        ),
      );
    }));
  }
}
