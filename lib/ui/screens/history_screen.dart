import 'dart:developer';

import 'package:fixbee_partner/blocs/history_bloc.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/active_order_history.dart';
import 'package:fixbee_partner/ui/custom_widget/credit.dart';
import 'package:fixbee_partner/ui/custom_widget/past_order.dart';
import 'package:fixbee_partner/ui/screens/past_order_billing_screen.dart';
import 'package:fixbee_partner/ui/screens/work_screen.dart';
import 'package:fixbee_partner/utils/dummy_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    _bloc.fire(HistoryEvent.fetchActiveOrder);
    print(_bloc.latestViewModel.pastOrderPresent.toString() + "PPP");
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
                  height: 32,
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
                              'IN-PROGRESS',
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
                    child: Text('DEBIT', style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child: FutureBuilder<HistoryModel>(
                      builder: (ctx, snapshot) {
                        if(!snapshot.hasData){
                          return CircularProgressIndicator();
                        }
                        else{
                          return (snapshot.data.pastOrderPresent)
                              ? ListView.builder(
                              itemCount: snapshot.data.pastOrderList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return PastOrder(
                                  backGroundColor: Colors.white,
                                  amount:
                                  snapshot.data.pastOrderList[index].totalAmount,
                                  serviceName:
                                  snapshot.data.pastOrderList[index].serviceName,
                                  status: snapshot.data.pastOrderList[index].status,
                                  timeStamp:
                                  snapshot.data.pastOrderList[index].timeStamp,
                                  seeMore: () {
                                    String orderID =
                                        snapshot.data.pastOrderList[index].orderId;
                                    print(orderID.toString() + "OOO");
                                    _bloc.fire(
                                        HistoryEvent.fetchAddOnsForEachOrder,
                                        message: {"orderID": orderID},
                                        onHandled: (e, m) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      PastOrderBillingScreen(
                                                        addOns:
                                                        snapshot.data.jobModel.addons,
                                                        cashOnDelivery: snapshot.data
                                                            .pastOrderList[index]
                                                            .cashOnDelivery,
                                                        orderId: snapshot.data
                                                            .pastOrderList[index]
                                                            .orderId,
                                                        serviceName: snapshot.data
                                                            .pastOrderList[index]
                                                            .serviceName,
                                                        address: snapshot.data
                                                            .pastOrderList[index]
                                                            .addressLine,
                                                        status: snapshot.data
                                                            .pastOrderList[index]
                                                            .status,
                                                        timeStamp: snapshot.data
                                                            .pastOrderList[index]
                                                            .timeStamp,
                                                        basePrice: snapshot.data
                                                            .pastOrderList[index]
                                                            .basePrice,
                                                        taxPercent: snapshot.data
                                                            .pastOrderList[index]
                                                            .taxPercent,
                                                        serviceCharge: snapshot.data
                                                            .pastOrderList[index]
                                                            .serviceCharge,
                                                        amount: snapshot.data
                                                            .pastOrderList[index]
                                                            .totalAmount,
                                                      )));
                                        });
                                  },
                                );
                              })
                              : Text('No Past Orders',
                              style: TextStyle(color: Colors.black));
                        }
                      },
                      future: _bloc.fetchPastOrders(),
                    ),
                  ),
                  Tab(
                    child: (viewModel.isOrderActive)
                        ? ActiveOrderHistory(
                            serviceName: viewModel.service.serviceName,
                            timeStamp: viewModel.order.timeStamp,
                            orderId: viewModel.order.orderId,
                            status: 'IN PROGRESS',
                            seeMore: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => WorkScreen(
                                        activeOrderStatus:
                                            viewModel.order.status,
                                        orderId: viewModel.order.orderId,
                                        googlePlaceId:
                                            viewModel.location.googlePlaceId,
                                        phoneNumber: viewModel.user.phoneNumber,
                                        userName: viewModel.user.firstname +
                                            " " +
                                            viewModel.user.middlename +
                                            " " +
                                            viewModel.user.lastname,
                                        userProfilePicUrl:
                                            viewModel.user.profilePicUrl,
                                        addressLine:
                                            viewModel.location.addressLine,
                                        landmark: viewModel.location.landmark,
                                        serviceName:
                                            viewModel.service.serviceName,
                                        timeStamp: viewModel.order.timeStamp,
                                        amount: viewModel.order.price,
                                        userProfilePicId:
                                            viewModel.user.profilePicId,
                                        cashOnDelivery:
                                            viewModel.order.cashOnDelivery,
                                        basePrice: viewModel.order.basePrice,
                                        taxPercent: viewModel.order.taxPercent,
                                        serviceCharge:
                                            viewModel.order.serviceCharge,
                                      ));
                              Navigator.pushReplacement(context, route);
                            },
                          )
                        : Text('No orders in progress',
                            style: TextStyle(color: Colors.black)),
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
