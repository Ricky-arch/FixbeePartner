import 'package:fixbee_partner/blocs/history_bloc.dart';
import 'package:fixbee_partner/events/history_event.dart';
import 'package:fixbee_partner/models/history_model.dart';
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
    _bloc.fire(HistoryEvent.fetchPastOrders);
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
                    child: (viewModel.pastOrderPresent)
                        ? ListView.builder(
                            itemCount: viewModel.pastOrderList.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return PastOrder(
                                amount:
                                    viewModel.pastOrderList[index].totalAmount,
                                serviceName:
                                    viewModel.pastOrderList[index].serviceName,
                                status: viewModel.pastOrderList[index].status,
                                timeStamp:
                                    viewModel.pastOrderList[index].timeStamp,
                                seeMore: () {
                                  String orderID = viewModel.pastOrderList[index].orderId;
                                  print(orderID.toString()+"OOO");
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
                                                      viewModel.jobModel.addons,
                                                  cashOnDelivery: viewModel
                                                      .pastOrderList[index]
                                                      .cashOnDelivery,
                                                  orderId: viewModel
                                                      .pastOrderList[index]
                                                      .orderId,
                                                  serviceName: viewModel
                                                      .pastOrderList[index]
                                                      .serviceName,
                                                  address: viewModel
                                                      .pastOrderList[index]
                                                      .addressLine,
                                                  status: viewModel
                                                      .pastOrderList[index]
                                                      .status,
                                                  timeStamp: viewModel
                                                      .pastOrderList[index]
                                                      .timeStamp,
                                                  basePrice: viewModel
                                                      .pastOrderList[index]
                                                      .basePrice,
                                                  taxPercent: viewModel
                                                      .pastOrderList[index]
                                                      .taxPercent,
                                                  serviceCharge: viewModel
                                                      .pastOrderList[index]
                                                      .serviceCharge,
                                                  amount: viewModel
                                                      .pastOrderList[index]
                                                      .totalAmount,
                                                )));
                                  });
                                },
                              );
                            })
                        : Image.asset("assets/logo/fixbeeLogo1.png"),
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
