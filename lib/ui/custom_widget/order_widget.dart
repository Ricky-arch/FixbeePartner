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
      this.index})
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
        decoration: BoxDecoration(
          color: PrimaryColors.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: PrimaryColors.whiteColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.userName.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "SERVICE :  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.orange),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          widget.serviceName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: PrimaryColors.whiteColor),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.orderMode.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.red),
                  )
                ],
              ),
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
                      color: PrimaryColors.whiteColor),
                )
              ])),
              Divider(
                color: Colors.tealAccent,
                thickness: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            print('Swiped right');
                            await widget.confirm(widget.orderId);
                          } else {
                            print('Swiped left');
                            await widget.decline(widget.index);
                          }
                        },
                        background: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: Text(
                            'DECLINE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                child: Text(
                                  'SWIPE RIGHT TO ACCEPT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: PrimaryColors.yellowColor,
                                      fontWeight: FontWeight.bold),
                                )),
                            Icon(
                              Icons.arrow_right_alt_rounded,
                              color: Colors.green,
                            )
                          ],
                        )),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
