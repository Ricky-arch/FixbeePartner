import 'dart:ui';
import 'package:fixbee_partner/blocs/billing_rating_bloc.dart';
import 'package:fixbee_partner/events/billing_rating_event.dart';
import 'package:fixbee_partner/models/billing_rating_model.dart';
import 'package:fixbee_partner/ui/custom_widget/addon.dart';
import 'package:fixbee_partner/ui/custom_widget/smiley_controller.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../Constants.dart';
import 'navigation_screen.dart';

class BillingRatingScreen extends StatefulWidget {
  final String orderId;
  final bool cashOnDelivery;

  const BillingRatingScreen({Key key, this.orderId, this.cashOnDelivery})
      : super(key: key);

  @override
  BillingRatingScreenState createState() => BillingRatingScreenState();
}

BillingRatingBloc _bloc;

class BillingRatingScreenState extends State<BillingRatingScreen> {
  DateTimeFormatter dtf = DateTimeFormatter();

  @override
  void initState() {
    _bloc = BillingRatingBloc(BillingRatingModel());
    _bloc.fire(BillingRatingEvent.fetchOderBillDetails,
        message: {'id': widget.orderId});

    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return WillPopScope(
        onWillPop: () async => !widget.cashOnDelivery,
        child: Scaffold(
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: RaisedButton(
              elevation: 4,
              color: PrimaryColors.backgroundColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Text(
                  'Rate user!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              onPressed: () {
                _showRatingBar();
              },
            ),
          ),
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
                              "ORDER RECEIPT",
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SelectableText(
                              "ORDER ID: ${widget.orderId}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (viewModel.whileFetchingBillDetails)
                        ? LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: PrimaryColors.backgroundColor,
                          )
                        : Column(
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
                                      "ORDER DETAILS",
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
                                    Banner(
                                      title: 'User',
                                      value: viewModel.receipt.userName,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 4, 16, 0),
                                      child: Divider(
                                        color: Colors.tealAccent,
                                      ),
                                    ),
                                    Banner(
                                      title: 'Reference Id',
                                      value: viewModel.receipt.referenceId,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 4, 16, 0),
                                      child: Divider(
                                        color: Colors.tealAccent,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.tealAccent)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "SERVICE DETAILS",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
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
                                                value: viewModel
                                                    .receipt
                                                    .services[index]
                                                    .serviceName,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 0),
                                                child: Divider(
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                              Banner(
                                                title: 'Price',
                                                value: Constants.rupeeSign +
                                                    ' ' +
                                                    viewModel.receipt
                                                        .services[index].amount
                                                        .toString(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 0),
                                                child: Divider(
                                                  color: (viewModel.receipt
                                                              .services.length >
                                                          1)
                                                      ? Colors.black
                                                      : Colors.tealAccent,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    (viewModel.receipt.payment == null)
                                        ? (widget.cashOnDelivery)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          color: Colors
                                                              .tealAccent)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "PAY ON WORK DONE",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          color: Colors
                                                              .tealAccent)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "PAYMENT YET TO BE DONE",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          color: Colors
                                                              .tealAccent)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "PAYMENT DETAILS",
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Banner(
                                                title: 'Amount',
                                                value: Constants.rupeeSign +
                                                    ' ' +
                                                    viewModel
                                                        .receipt.payment.amount
                                                        .toString(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 0),
                                                child: Divider(
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                              Banner(
                                                title: 'Status',
                                                value: viewModel
                                                    .receipt.payment.status,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 0),
                                                child: Divider(
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                              Banner(
                                                title: 'Method',
                                                value: viewModel
                                                    .receipt.payment.method,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 0),
                                                child: Divider(
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                              Banner(
                                                title: 'Captured',
                                                value: viewModel
                                                    .receipt.payment.captured
                                                    .toString()
                                                    .toUpperCase(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 0),
                                                child: Divider(
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                              (viewModel.receipt.payment
                                                          .refundStatus !=
                                                      null)
                                                  ? Column(
                                                      children: [
                                                        Banner(
                                                          title:
                                                              'Refund Status',
                                                          value: viewModel
                                                              .receipt
                                                              .payment
                                                              .refundStatus,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  16.0,
                                                                  4,
                                                                  16,
                                                                  0),
                                                          child: Divider(
                                                            color: Colors
                                                                .tealAccent,
                                                          ),
                                                        ),
                                                        Banner(
                                                          title:
                                                              'Refund Amount',
                                                          value: Constants
                                                                  .rupeeSign +
                                                              ' ' +
                                                              viewModel
                                                                  .receipt
                                                                  .payment
                                                                  .amountRefunded
                                                                  .toString(),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  16.0,
                                                                  4,
                                                                  16,
                                                                  0),
                                                          child: Divider(
                                                            color: Colors
                                                                .tealAccent,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.tealAccent)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "TOTAL PRICE",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                Constants.rupeeSign +
                                                    ' ' +
                                                    viewModel.receipt.amount
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _showRatingBar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: CustomRating(
              userName: _bloc.latestViewModel.receipt.userName,
              // userID: widget.userID,
            ),
          );
        });
  }
}

class Banner extends StatelessWidget {
  final String title, value;

  const Banner({Key key, this.title, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 50,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: SelectableText(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRating extends StatefulWidget {
  final String userName;

  final String userID;

  const CustomRating({Key key, this.userName, this.userID}) : super(key: key);

  @override
  _CustomRatingState createState() => _CustomRatingState();
}

class _CustomRatingState extends State<CustomRating> {
  double _rating = 5.0;
  String _currentAnimation = '5+';
  SmileyController _smileyController = SmileyController();
  TextEditingController shortReview = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    shortReview.clear();
    shortReview.dispose();

    super.dispose();
  }

  void _onChanged(double value) {
    if (_rating == value) return;

    setState(() {
      var direction = _rating < value ? '+' : '-';
      _rating = value;
      _currentAnimation = '${value.round()}$direction';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Slider(
                  inactiveColor: PrimaryColors.yellowColor,
                  activeColor: PrimaryColors.backgroundColor,
                  value: _rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: _onChanged,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Rate user ${widget.userName}: ",
                        style: TextStyle(
                            color: PrimaryColors.backgroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '$_rating',
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "\u2605",
                        style: TextStyle(color: Colors.amber, fontSize: 22))
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add an short review?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                  child: TextFormField(
                    cursorColor: PrimaryColors.backgroundColor,
                    controller: shortReview,
                    decoration: InputDecoration(
                        hintText: "Write here...",
                        filled: true,
                        fillColor: PrimaryColors.backgroundcolorlight),
                    maxLines: null,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                      color: PrimaryColors.yellowColor.withOpacity(.5),
                      onPressed: () {
                        _bloc.fire(BillingRatingEvent.addRatingEvent, message: {
                          "accountID": widget.userID,
                          "Score": _rating.toInt(),
                          "Review": shortReview.text.toString()
                        }, onHandled: (e, m) {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "CONFIRM",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                      )),
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: Container(
              height: MediaQuery.of(context).size.width / 3.2,
              width: MediaQuery.of(context).size.width / 3.2,
              child: FlareActor(
                "assets/animations/happiness_emoji.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                controller: _smileyController,
                animation: _currentAnimation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
