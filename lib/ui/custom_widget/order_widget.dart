import 'package:flutter/material.dart';

import '../../Constants.dart';

class OrderWidget extends StatefulWidget {
  final String serviceName, userName, userPhone, orderAddress, orderMode;
  final Function confirm, decline;

  const OrderWidget(
      {Key key,
      this.serviceName,
      this.userName,
      this.userPhone,
      this.orderAddress,
      this.orderMode,
      this.confirm,
      this.decline})
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Row(
                  children: [
                    InkWell(
                      child: GestureDetector(
                        onTap: widget.confirm,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.orangeAccent.withOpacity(.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "CONFIRM",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      child: GestureDetector(
                        onTap: widget.confirm,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.orangeAccent.withOpacity(.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "DECLINE",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
