import 'dart:ui';
import 'package:fixbee_partner/blocs/billing_rating_bloc.dart';
import 'package:fixbee_partner/events/billing_rating_event.dart';
import 'package:fixbee_partner/models/billing_rating_model.dart';
import 'package:fixbee_partner/ui/custom_widget/addon.dart';
import 'package:fixbee_partner/ui/custom_widget/smiley_controller.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:fixbee_partner/utils/colors.dart';
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
                    (viewModel.whileFetchingBillDetails)
                        ? LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: PrimaryColors.backgroundColor,
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
                                                value: viewModel
                                                    .receipt
                                                    .services[index]
                                                    .serviceName,
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
                                                          title:
                                                              'Refund Status',
                                                          value: viewModel
                                                              .receipt
                                                              .payment
                                                              .refundStatus,
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
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                    subTitleWithValue("TOTAL PRICE",
                                        viewModel.receipt.amount),
                                    subTitleWithValue('YOUR SERVICE CHARGE',
                                        viewModel.receipt.serviceCharge)
                                  ],
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    applicationIcon(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            _showRatingBar();
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Rate User",
                            style:
                                TextStyle(color: Theme.of(context).canvasColor),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton(
                          mini: true,
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).canvasColor,
                            size: 30,
                          ),
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => NavigationScreen());
                            Navigator.pushAndRemoveUntil(
                                context, route, (e) => false);
                          },
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
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
              orderId: widget.orderId,
              ratings: (value) {
                _bloc.fire(BillingRatingEvent.addRatingEvent,
                    message: {
                      "id": widget.orderId,
                      "Score": value['Score'],
                      "Review": value['Review']
                    },
                    onHandled: (e, m) {});
              },
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

  Widget applicationIcon() {
    return Center(
        child: Image.asset(
      "assets/logo/splash_logo.png",
      width: MediaQuery.of(context).size.width / 5,
    ));
  }
}

class Banner extends StatelessWidget {
  final String title, value;

  const Banner({Key key, this.title, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionColor: FixbeeColors.kCardColorLighter,
                ),
                child: SelectableText(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRating extends StatefulWidget {
  final Function(Map<String, dynamic>) ratings;
  final String userName;

  final String orderId;

  const CustomRating({Key key, this.userName, this.orderId, this.ratings})
      : super(key: key);

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
                top: Constants.avatarRadius +
                    MediaQuery.of(context).size.width / 30,
                right: Constants.padding,
                bottom: MediaQuery.of(context).size.width / 30),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "\u2605",
                        style: TextStyle(color: Colors.amber, fontSize: 18))
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Add an short review?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 0),
                  child: TextFormField(
                    cursorColor: PrimaryColors.backgroundColor,
                    controller: shortReview,
                    decoration: InputDecoration(
                        hintText: "Write here...",
                        filled: true,
                        fillColor: PrimaryColors.backgroundcolorlight),
                    maxLines: null,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Theme.of(context).canvasColor),
                    keyboardType: TextInputType.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        height: MediaQuery.of(context).size.height / 20,
                        color: PrimaryColors.yellowColor.withOpacity(.5),
                        onPressed: () {
                          widget.ratings({
                            'id': widget.orderId,
                            'Score': _rating.toInt(),
                            'Review': shortReview.text.toString()
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "CONFIRM",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: Container(
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
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
