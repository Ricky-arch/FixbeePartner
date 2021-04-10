import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/debit.dart';
import 'package:fixbee_partner/ui/custom_widget/paginated_list.dart';
import 'package:fixbee_partner/ui/custom_widget/past_order.dart';
import 'package:fixbee_partner/ui/screens/past_order_billing_screen.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class PastOrderScreen extends StatefulWidget {
  final Future<List<Orders>> Function(int skip) listOfOrders;

  const PastOrderScreen({Key key, this.listOfOrders}) : super(key: key);
  @override
  _PastOrderScreenState createState() => _PastOrderScreenState();
}

class _PastOrderScreenState extends State<PastOrderScreen> {
  PaginatedListViewController<Orders> _controller;
  final int limit = 10;

  @override
  void initState() {
    _controller =
        PaginatedListViewController<Orders>(widget.listOfOrders, limit);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginatedListView<Orders>(
          placeHolderWidget: CustomCircularProgressIndicator(),
          emptyListWidget: Center(
            child: Text('No past Orders!'),
          ),
          separator: SizedBox(),
          firstPageErrorWidget:
              Center(child: Text('Error while loading start')),
          nextPageErrorWidget: Center(child: Text('Failed to fetch more orders!')),
          controller: _controller,
          loaderWidget: Center(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomCircularProgressIndicator(),
          )),
          endOfPagesMarkerWidget: SizedBox(),
          listItemBuilder: (ctx, index, pastOrder) {
            return PastOrder(
              orderId: pastOrder.id,
              cashOnDelivery: pastOrder.cashOnDelivery,
              seeMore: (value, cashOnDelivery) {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return PastOrderBillingScreen(
                    cashOnDelivery: cashOnDelivery,
                    orderId: value,
                  );
                }));
              },
              backGroundColor: Theme.of(context).cardColor,
              amount: pastOrder.amount,
              loading: false,
              serviceName: pastOrder.serviceName,
              status: pastOrder.status,
              timeStamp: pastOrder.timeStamp,
            );
          }),
    );
  }
}
