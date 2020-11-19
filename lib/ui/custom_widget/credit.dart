import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class Credit extends StatefulWidget {
  final int amount;
  final String date;
  final String notes;

  const Credit({Key key, this.amount, this.date, this.notes}) : super(key: key);
  @override
  _CreditState createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  DateTimeFormatter dtf = DateTimeFormatter();
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
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Your wallet has been credited with ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: PrimaryColors.backgroundColor),
                    ),
                    TextSpan(
                      text: Constants.rupeeSign +
                          (widget.amount / 100).toStringAsFixed(2),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20),
                    )
                  ]),
                )),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "DATE:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    decoration: BoxDecoration(
//                      color: Colors.yellow.withOpacity(.5),
//                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dtf.getDate(widget.date),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "TIME:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    decoration: BoxDecoration(
//                      color: Colors.yellow.withOpacity(.5),
//                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dtf.getTime(widget.date),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:12.0, right: 12),
              child: Divider(

                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "PAYMENT ID:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.notes,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
