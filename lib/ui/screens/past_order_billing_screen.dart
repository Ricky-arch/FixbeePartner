import 'dart:developer';
import 'dart:ui';

import 'package:fixbee_partner/blocs/billing_rating_bloc.dart';
import 'package:fixbee_partner/events/billing_rating_event.dart';
import 'package:fixbee_partner/models/billing_rating_model.dart';
import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/addon.dart';
import 'package:fixbee_partner/utils/colors.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../Constants.dart';

class PastOrderBillingScreen extends StatefulWidget {
  //final Receipt receipt;
  final String orderId;
  final bool cashOnDelivery;

  const PastOrderBillingScreen({Key key, this.orderId, this.cashOnDelivery})
      : super(key: key);
  @override
  _PastOrderBillingScreenState createState() => _PastOrderBillingScreenState();
}

class _PastOrderBillingScreenState extends State<PastOrderBillingScreen> {
  DateTimeFormatter dtf = DateTimeFormatter();
  BillingRatingBloc _bloc;

  @override
  void initState() {
    _bloc = BillingRatingBloc(BillingRatingModel());
    _bloc.fire(BillingRatingEvent.fetchOderBillDetails,
        message: {'id': widget.orderId});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    child: Theme(
                        child: SelectableText.rich(TextSpan(children: [
                          TextSpan(
                            text: "Order Receipt\n\n",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                          ),
                          TextSpan(
                            text: "Order Id: ${widget.orderId}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ])),
                        data: Theme.of(context).copyWith(
                          textSelectionColor: FixbeeColors.kCardColorLighter,
                        )),
                  ),
                  // applicationIcon(),
                  (viewModel.whileFetchingBillDetails)
                      ? LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).accentColor),
                          backgroundColor: Theme.of(context).canvasColor,
                        )
                      : Column(
                          children: [
                            subTitle('ORDER DETAILS'),
                            Container(
                              child: Column(
                                children: [
                                  Banner(
                                    title: 'User',
                                    value: viewModel.receipt.userName,
                                  ),
                                  Banner(
                                    title: 'Reference Id',
                                    showCopyIcon: true,
                                    value: viewModel.receipt.referenceId,
                                  ),

                                  subTitle('SERVICE DETAILS'),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          viewModel.receipt.services.length,
                                      itemBuilder: (ctx, index) {
                                        return Column(
                                          children: [
                                            Banner(
                                              title: 'Service',
                                              value: viewModel.receipt
                                                  .services[index].serviceName,
                                            ),

                                            Banner(
                                              title: 'Price',
                                              value: Constants.rupeeSign +
                                                  ' ' +
                                                  (viewModel
                                                              .receipt
                                                              .services[index]
                                                              .amount /
                                                          100)
                                                      .toStringAsFixed(2),
                                            ),

                                          ],
                                        );
                                      }),
                                  (viewModel.receipt.payment == null)
                                      ? (widget.cashOnDelivery)
                                          ? subTitle('PAY ON WORK DONE')
                                          : subTitle('PAYMENT YET TO BE DONE')
                                      : Column(
                                          children: [
                                            subTitle('PAYMENT DETAILS'),
                                            Banner(
                                              title: 'Amount',
                                              value: Constants.rupeeSign +
                                                  ' ' +
                                                  (viewModel.receipt.payment
                                                              .amount /
                                                          100)
                                                      .toStringAsFixed(2),
                                            ),

                                            Banner(
                                              title: 'Status',
                                              value: viewModel
                                                  .receipt.payment.status,
                                            ),

                                            Banner(
                                              title: 'Method',
                                              value: viewModel
                                                  .receipt.payment.method,
                                            ),

                                            Banner(
                                              title: 'Captured',
                                              value: viewModel
                                                  .receipt.payment.captured
                                                  .toString()
                                                  .toUpperCase(),
                                            ),

                                            (viewModel.receipt.payment
                                                        .refundStatus !=
                                                    null)
                                                ? Column(
                                                    children: [
                                                      Banner(
                                                        title: 'Refund Status',
                                                        value: viewModel
                                                            .receipt
                                                            .payment
                                                            .refundStatus,
                                                      ),

                                                      Banner(
                                                        title: 'Refund Amount',
                                                        value: Constants
                                                                .rupeeSign +
                                                            ' ' +
                                                            viewModel
                                                                .receipt
                                                                .payment
                                                                .amountRefunded
                                                                .toString(),
                                                      ),

                                                    ],
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                  subTitleWithValue('TOTAL PRICE', viewModel.receipt.amount),
                                  subTitleWithValue('YOUR SERVICE CHARGE', viewModel.receipt
                                      .serviceCharge),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            applicationIcon(),
                            SizedBox(height: 20,)
                          ],
                        ),

                ],
              ),

            ],
          ),
        ),
      );
    });
  }

  Widget subTitle(title) {
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

  Widget subTitleWithValue(title, value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Constants.rupeeSign + ' ' + (value / 100).toStringAsFixed(2),
                style: TextStyle(
                    color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget applicationIcon(){
    return Center(
        child:  Image.asset(
          "assets/logo/splash_logo.png",
          width: MediaQuery.of(context).size.width / 5,

        )

    );
  }
}

class Banner extends StatelessWidget {
  final String title, value;
  final Function copy;
  final bool showCopyIcon;

  const Banner(
      {Key key, this.title, this.value, this.copy, this.showCopyIcon = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 10,
                ),
                (showCopyIcon)
                    ? GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                              new ClipboardData(text: value));
                          _showSnackBar(context);
                        },
                        child: Icon(
                          Icons.copy,
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ))
                    : SizedBox(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Theme(
                child: SelectableText(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: null,
                ),
                data: Theme.of(context).copyWith(
    textSelectionColor: FixbeeColors.kCardColorLighter,)


              ),
            ),
          ),
        ],
      ),
    );
  }

  _showSnackBar(context) {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Reference id copied to clipboard!')));
  }
}
