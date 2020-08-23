import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class NewServiceNotification extends StatefulWidget {
  final String userName;
  final String orderId;
  final String paymentMode;
  final String address;
  final Function onConfirm;
  final Function onDecline;

  const NewServiceNotification(
      {Key key,
      this.userName,
      this.orderId,
      this.paymentMode,
      this.address,
      this.onConfirm,
      this.onDecline})
      : super(key: key);
  @override
  _NewServiceNotificationState createState() => _NewServiceNotificationState();
}

class _NewServiceNotificationState extends State<NewServiceNotification> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: PrimaryColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (widget.orderId != null)
                        ? "#Order ID: ${widget.orderId}"
                        : "#Order ID: 1234567890",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
              child: Divider(
                thickness: 2,
              ),
            ),
            Container(
              child: Text(
                (widget.userName != null) ? widget.userName : "Ram Nath Kovind",
                style: TextStyle(
                    color: PrimaryColors.backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                maxLines: null,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                (widget.address != null) ? widget.address : "Udaipur",
                style: TextStyle(
                    color: PrimaryColors.backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
                maxLines: null,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                (widget.paymentMode != null)
                    ? "Payment Mode: ${widget.paymentMode.toUpperCase()}"
                    : "Payment Mode",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: widget.onConfirm,
                  color: PrimaryColors.backgroundColor,
                  child: Text("CONFIRM", style: TextStyle(color: Colors.white)),
                ),
                Container(
                  color: PrimaryColors.backgroundColor,
                  height: 30,
                  width: 2,
                ),
                OutlineButton(
                  color: PrimaryColors.backgroundColor,
                  onPressed: widget.onDecline,
                  child: Text(
                    "DECLINE",
                    style: TextStyle(color: PrimaryColors.backgroundColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )
      ],
    );
  }
}
