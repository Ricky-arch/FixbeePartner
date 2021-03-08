import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import 'custom_panel.dart';

class TransactionDetailed extends StatefulWidget {
  final Transactions transaction;

  const TransactionDetailed({Key key, this.transaction}) : super(key: key);
  @override
  _TransactionDetailedState createState() => _TransactionDetailedState();
}

class _TransactionDetailedState extends State<TransactionDetailed> {
  DateTimeFormatter dtf = DateTimeFormatter();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: PrimaryColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TRANSACTION RECEIPT",
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "REFERENCE ID: ${widget.transaction.referenceId}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                    widget.transaction.column.toUpperCase(),
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  CustomPanel(
                    title: 'Amount:',
                    value: Constants.rupeeSign +
                        " " +
                        (widget.transaction.amount/100).toStringAsFixed(2),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                    child: Divider(
                      color: Colors.tealAccent,
                    ),
                  ),
                  (widget.transaction.fundAccountID != null)
                      ? Column(
                          children: [
                            CustomPanel(
                              title: 'Funds Account Id:',
                              value: widget.transaction.fundAccountID,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                              child: Divider(
                                color: Colors.tealAccent,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  (widget.transaction.payoutId != null)
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border:
                                        Border.all(color: Colors.tealAccent)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "PAYOUT",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            CustomPanel(
                              title: 'Payout Id:',
                              value: widget.transaction.payoutId,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                              child: Divider(
                                color: Colors.tealAccent,
                              ),
                            ),
                            CustomPanel(
                              title: 'Status:',
                              value:
                                  widget.transaction.payout.status.toUpperCase(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                              child: Divider(
                                color: Colors.tealAccent,
                              ),
                            ),
                            CustomPanel(
                              title: 'Mode:',
                              value: widget.transaction.payout.mode,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                              child: Divider(
                                color: Colors.tealAccent,
                              ),
                            ),
                            CustomPanel(
                              title: 'Utr:',
                              value: widget.transaction.payout.utr,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                              child: Divider(
                                color: Colors.tealAccent,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  (widget.transaction.paymentId != null)
                      ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              border:
                              Border.all(color: Colors.tealAccent)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "PAYMENT",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      CustomPanel(
                        title: 'Payment Id:',
                        value: widget.transaction.paymentId,
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                        child: Divider(
                          color: Colors.tealAccent,
                        ),
                      ),

                    ],
                  )
                      : SizedBox(),
                  (widget.transaction.payment.status!=null)?Column(
                    children: [
                      CustomPanel(
                        title: 'Status:',
                        value:
                        widget.transaction.payment.status.toUpperCase(),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                        child: Divider(
                          color: Colors.tealAccent,
                        ),
                      ),
                      CustomPanel(
                        title: 'Method:',
                        value: widget.transaction.payment.method.toUpperCase(),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                        child: Divider(
                          color: Colors.tealAccent,
                        ),
                      ),
                      (widget.transaction.payment.refundStatus!=null)?Column(
                        children: [
                          CustomPanel(
                            title: 'Refund Status:',
                            value: widget.transaction.payment.refundStatus,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                            child: Divider(
                              color: Colors.tealAccent,
                            ),
                          ),
                          CustomPanel(
                            title: 'Amount Refunded:',
                            value: widget.transaction.payment.amountRefunded,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                            child: Divider(
                              color: Colors.tealAccent,
                            ),
                          ),
                        ],
                      ):SizedBox(),


                    ],
                  ):SizedBox(),
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
                          "CREATED AT",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  CustomPanel(
                    title: 'Date:',
                    value: dtf.getDate(widget.transaction.createdAt),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                    child: Divider(
                      color: Colors.tealAccent,
                    ),
                  ),
                  CustomPanel(
                    title: 'Time:',
                    value: dtf.getTime(widget.transaction.createdAt),
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
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
