import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class TransactionCard extends StatefulWidget {
  final Transactions transaction;
  final Function seeMore;

  const TransactionCard({Key key, this.transaction, this.seeMore})
      : super(key: key);
  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  DateTimeFormatter dtf = DateTimeFormatter();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: PrimaryColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.tealAccent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: widget.transaction.column.toUpperCase() + " : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: PrimaryColors.backgroundColor),
                  ),
                  TextSpan(
                    text: Constants.rupeeSign +
                        (widget.transaction.amount / 100).toStringAsFixed(2),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  )
                ]),
              ),
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
                        onTap: widget.seeMore,
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
                              "SEE MORE",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(dtf.getDate(widget.transaction.createdAt)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(dtf.getTime(widget.transaction.createdAt)),
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
