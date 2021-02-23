import 'dart:developer';

import 'package:fixbee_partner/ui/custom_widget/banner_panel.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class DebitInfo extends StatefulWidget {
  final int amount;
  final String timeStamp,
      orderId,
      accountId,
      withDrawlAccountNumber,
      withDrawlAccountHolderName,
      withDrawlTransactionId;
  final bool debitOnOrder;

  const DebitInfo(
      {Key key,
      this.amount,
      this.timeStamp,
      this.orderId,
      this.accountId,
      this.withDrawlAccountNumber,
      this.withDrawlAccountHolderName,
      this.withDrawlTransactionId,
      this.debitOnOrder})
      : super(key: key);
  @override
  _DebitInfoState createState() => _DebitInfoState();
}

class _DebitInfoState extends State<DebitInfo> {
  DateTimeFormatter dtf = DateTimeFormatter();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.tealAccent)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "DEBIT INFO",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            BannerPanel(
              title: "Amount",
              value: Constants.rupeeSign +
                  " " +
                  (widget.amount / 100).toStringAsFixed(2),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
              child: Divider(
                color: Colors.tealAccent,
              ),
            ),

            BannerPanel(
              title: "Date:",
              value: dtf.getDate(widget.timeStamp),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
              child: Divider(
                color: Colors.tealAccent,
              ),
            ),
            BannerPanel(
              title: "Time:",
              value: dtf.getTime(widget.timeStamp),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
              child: Divider(
                color: Colors.tealAccent,
              ),
            ),


            (!widget.debitOnOrder)
                ? Container(
                    child: Column(
                      children: [
                        BannerPanel(
                          title: "Transaction Id:",
                          value: widget.withDrawlTransactionId,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                          child: Divider(
                            color: Colors.tealAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.tealAccent)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "WITHDRAWAL ACCOUNT INFO",
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        BannerPanel(
                          title: "Bank Account Number:",
                          value: widget.withDrawlAccountNumber,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                          child: Divider(
                            color: Colors.tealAccent,
                          ),
                        ),
                        BannerPanel(
                          title: "Account Holder Name",
                          value: widget.withDrawlAccountHolderName,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                          child: Divider(
                            color: Colors.tealAccent,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.tealAccent)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ORDER INFO",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  BannerPanel(
                    title: "Order Id:",
                    value: widget.orderId,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                    child: Divider(
                      color: Colors.tealAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
