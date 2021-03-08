import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/banner_panel.dart';
import 'package:fixbee_partner/ui/custom_widget/order_widget.dart';
import 'package:flutter/material.dart';

class OrderNotification extends StatefulWidget {
  final OrderNotificationModel orderNotification;
  final List<OrderNotificationModel> orderNotificationList;
  final Future<void> Function(String) confirm;
  final Function decline;

  const OrderNotification(
      {Key key,
      this.orderNotification,
      this.orderNotificationList,
      this.confirm,
      this.decline})
      : super(key: key);
  @override
  _OrderNotificationState createState() => _OrderNotificationState();
}

class _OrderNotificationState extends State<OrderNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: (widget.orderNotificationList == null ||
                widget.orderNotificationList.length == 0)
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8.0),
                child: Center(
                  child: Text(
                    "NO WORRIES YOU WILL SOON RECEIVE  ORDER!",
                    style: TextStyle(
                        color: PrimaryColors.yellowColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // margin: const EdgeInsets.all(12.0),
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "YOUR ORDERS",
                      style: TextStyle(
                          color: PrimaryColors.yellowColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.orderNotificationList.length,
                      itemBuilder: (ctx, index) {
                        return OrderWidget(
                          orderId: widget.orderNotificationList[index].orderId,
                          userName:
                              widget.orderNotificationList[index].userName,
                          serviceName:
                              widget.orderNotificationList[index].serviceName,
                          confirm: widget.confirm,
                          decline: widget.decline,
                          orderAddress:
                              widget.orderNotificationList[index].orderAddress,
                          orderMode:
                              widget.orderNotificationList[index].cashOnDelivery
                                  ? 'COD'
                                  : 'ONLINE',
                        );
                      }),
                ],
              ),
      ),
    );
  }
}
