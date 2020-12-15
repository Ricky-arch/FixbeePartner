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
  final bool loading;
  final Function(bool) onChanged;

  const NewServiceNotification(
      {Key key,
      this.userName,
      this.orderId,
      this.paymentMode,
      this.address,
      this.onConfirm,
      this.onDecline,
      this.loading = false, this.onChanged})
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
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: PrimaryColors.backgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "NEW ORDER NOTIFICATION",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (widget.orderId != null)
                          ? "ORDER ID: #${widget.orderId}"
                          : "ORDER ID: #1234567890",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColors.backgroundcolorlight),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 10,),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                (widget.loading)
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 50.0,
                        ),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: PrimaryColors.backgroundColor,
                        ),
                      )
                    : FlatButton(
                        onPressed: widget.onConfirm,
                        color: PrimaryColors.backgroundColor,
                        child: Text("CONFIRM",
                            style: TextStyle(color: Colors.white)),
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
