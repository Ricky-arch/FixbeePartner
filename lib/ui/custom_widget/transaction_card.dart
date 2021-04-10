import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/utils/colors.dart';
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.transaction.column.toUpperCase() + " : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        color: FixbeeColors.kCardColorLighter,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      Constants.rupeeSign +
                          (widget.transaction.amount / 100).toStringAsFixed(2),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(8,8,8,8),
                child: Divider(
                  color: Theme.of(context).hintColor,
                  thickness: .5,
                ),
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
                            borderRadius: BorderRadius.circular(50.0),
                            color: Theme.of(context).primaryColor,
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
                                  fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).cardColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: FixbeeColors.kCardColorLighter,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child:
                              Text(dtf.getDate(widget.transaction.createdAt))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            color: FixbeeColors.kCardColorLighter,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child:
                            Text(dtf.getTime(widget.transaction.createdAt))),
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
