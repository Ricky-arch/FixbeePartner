import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/utils/colors.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                        Row(
                          children: [
                            Expanded(
                              child: Theme(
                                  child:
                                      SelectableText.rich(TextSpan(children: [
                                    TextSpan(
                                      text: "Transaction Receipt\n\n",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    TextSpan(
                                      text:
                                          "Reference Id: ${widget.transaction.referenceId}",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ])),
                                  data: Theme.of(context).copyWith(
                                    textSelectionColor:
                                        FixbeeColors.kCardColorLighter,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(new ClipboardData(
                                        text: widget.transaction.referenceId));
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            'Reference id copied to clipboard!')));
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: Theme.of(context).hintColor,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            subTitle(widget.transaction.column.toUpperCase()),
            Container(
              child: Column(

                children: [

                  CustomPanel(
                    title: 'Amount:',
                    value: Constants.rupeeSign +
                        " " +
                        (widget.transaction.amount / 100).toStringAsFixed(2),
                  ),

                  (widget.transaction.fundAccountID != null)
                      ? CustomPanel(
                        title: 'Funds Account Id:',
                        value: widget.transaction.fundAccountID,
                      )
                      : SizedBox(),
                  (widget.transaction.payoutId != null)
                      ? Column(
                          children: [
                            subTitle('PAYOUT'),
                            CustomPanel(
                              title: 'Payout Id:',
                              value: widget.transaction.payoutId,
                            ),

                            CustomPanel(
                              title: 'Status:',
                              value: widget.transaction.payout.status
                                  .toUpperCase(),
                            ),

                            CustomPanel(
                              title: 'Mode:',
                              value: widget.transaction.payout.mode,
                            ),

                            (widget.transaction.payout.utr != null)
                                ? CustomPanel(
                                    title: 'Utr:',
                                    value: widget.transaction.payout.utr,
                                  )
                                : SizedBox(),
                            // (widget.transaction.payout.utr != null)
                            //     ? Padding(
                            //         padding: const EdgeInsets.fromLTRB(
                            //             16.0, 4, 16, 0),
                            //         child: Divider(
                            //           color: Colors.tealAccent,
                            //         ),
                            //       )
                            //     : SizedBox(),
                          ],
                        )
                      : SizedBox(),
                  (widget.transaction.paymentId != null)
                      ? Column(
                          children: [
                            subTitle('PAYMENT'),
                            CustomPanel(
                              title: 'Payment Id:',
                              value: widget.transaction.paymentId,
                            ),

                          ],
                        )
                      : SizedBox(),
                  (widget.transaction.payment.status != null)
                      ? Column(
                          children: [
                            CustomPanel(
                              title: 'Status:',
                              value: widget.transaction.payment.status
                                  .toUpperCase(),
                            ),
                            CustomPanel(
                              title: 'Method:',
                              value: widget.transaction.payment.method
                                  .toUpperCase(),
                            ),

                            (widget.transaction.payment.refundStatus != null)
                                ? Column(
                                    children: [
                                      CustomPanel(
                                        title: 'Refund Status:',
                                        value: widget
                                            .transaction.payment.refundStatus,
                                      ),

                                      CustomPanel(
                                        title: 'Amount Refunded:',
                                        value: Constants.rupeeSign +
                                            ' ' +
                                            widget.transaction.payment
                                                .amountRefunded
                                                .toString(),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            (widget.transaction.payment.captured != null)
                                ? CustomPanel(
                                  title: 'Captured:',
                                  value: widget
                                      .transaction.payment.captured
                                      .toString()
                                      .toUpperCase(),
                                )
                                : SizedBox()
                          ],
                        )
                      : SizedBox(),
                  subTitle('CREATED AT'),
                  CustomPanel(
                    title: 'Date:',
                    value: dtf.getDate(widget.transaction.createdAt),
                  ),

                  CustomPanel(
                    title: 'Time:',
                    value: dtf.getTime(widget.transaction.createdAt),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            applicationIcon(),
            SizedBox(height: 30,),
            // Image.asset();
          ],
        ),
      ),
    );
  }
  Widget subTitle(title){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
  Widget applicationIcon(){
    return Center(
        child:  Image.asset(
          "assets/logo/splash_logo.png",
          width: MediaQuery.of(context).size.width / 5,
          //height: MediaQuery.of(context).size.height / 2,
        )

    );
  }
}
