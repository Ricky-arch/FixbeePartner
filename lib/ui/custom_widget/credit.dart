import 'package:flutter/material.dart';

import '../../Constants.dart';

class Credit extends StatefulWidget {
  final int amount;
  final String date;

  const Credit({Key key, this.amount, this.date}) : super(key: key);
  @override
  _CreditState createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Your account has been credit with ${widget.amount}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(),
                  Text("Time-Stamp:"),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(.5),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.date,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
