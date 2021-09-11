import 'package:flutter/material.dart';

import '../../Constants.dart';

class OrderWidget extends StatefulWidget {
  final String serviceName,
      userName,
      userPhone,
      orderAddress,
      orderMode,
      orderId;
  final int index;
  final bool assignedOrder;
  final Future<void> Function(String) confirm;
  final Future<void> Function(int) decline;

  const OrderWidget(
      {Key key,
      this.serviceName,
      this.userName,
      this.userPhone,
      this.orderAddress,
      this.orderMode,
      this.confirm,
      this.decline,
      this.orderId,
      this.index,
      this.assignedOrder = false})
      : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'NAME :  ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.orange),
                ),
                TextSpan(
                  text: widget.userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).accentColor),
                )
              ])),
              Row(
                children: [
                  Text(
                    "SERVICE :  ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.orange),
                  ),
                  Expanded(
                    child: Text(
                      widget.serviceName ?? "Test",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'MODE :  ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.orange),
                ),
                TextSpan(
                  text: widget.orderMode.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).accentColor),
                )
              ])),
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'ADDRESS :  ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.orange),
                ),
                TextSpan(
                  text: widget.orderAddress,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).accentColor),
                )
              ])),
              (!widget.assignedOrder)
                  ? Divider(
                      color: Colors.tealAccent,
                      thickness: 1,
                    )
                  : SizedBox(),
              (!widget.assignedOrder)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Dismissible(
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  await widget.confirm(widget.orderId);
                                } else {
                                  await widget.decline(widget.index);
                                }
                              },
                              background: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                alignment: Alignment.centerLeft,
                                color: Colors.green,
                                child: Text(
                                  'ACCEPT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              secondaryBackground: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                child: Text(
                                  'DECLINE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SWIPE RIGHT TO ACCEPT',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.arrow_right_alt_rounded,
                                        color: Theme.of(context).canvasColor,
                                      )
                                    ],
                                  ))),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
