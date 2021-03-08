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
  // final String orderID, userID;

  // const BillingRatingScreen({Key key, this.orderID, this.userID})
  //     : super(key: key);

  @override
  BillingRatingScreenState createState() => BillingRatingScreenState();
}

BillingRatingBloc _bloc;

class BillingRatingScreenState extends State<BillingRatingScreen> {
  DateTimeFormatter dtf = DateTimeFormatter();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _bloc = BillingRatingBloc(BillingRatingModel());
    // _bloc.fire(BillingRatingEvent.fetchOderBillDetails,
    //     message: {"orderID": widget.orderID});
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
        onWillPop: () async => false,
        child: Scaffold(
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
                                Text(
                                  "ORDER RECEIPT",
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                (viewModel.whileFetchingBillDetails)
                                    ? SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              PrimaryColors.backgroundColor,
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "ORDER ID: 1234567890",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    (viewModel.whileFetchingBillDetails)
                        ? Container()
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
                                      value: 'Saurav',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 4, 16, 0),
                                      child: Divider(
                                        color: Colors.tealAccent,
                                      ),
                                    ),
                                    Banner(
                                      title: 'Address',
                                      value: 'Ram nagar',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 4, 16, 0),
                                      child: Divider(
                                        color: Colors.tealAccent,
                                      ),
                                    ),
                                    Banner(
                                      title: 'Status',
                                      value: viewModel.orderModel.status,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 4, 16, 0),
                                      child: Divider(
                                        color: Colors.tealAccent,
                                      ),
                                    ),
                                    Banner(
                                      title: 'Date',
                                      value: dtf.getDate(
                                          DateTime.now().toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 4, 16, 0),
                                      child: Divider(
                                        color: Colors.tealAccent,
                                      ),
                                    ),
                                    Banner(
                                      title: 'Time',
                                      value: dtf.getTime(
                                          DateTime.now().toString()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
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
                                      "BASE SERVICE DETAILS",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   child: Column(
                              //     children: [
                              //       Banner(
                              //         title: 'Service ',
                              //         value: viewModel.orderModel.serviceName,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Quantity',
                              //         value: (viewModel.orderModel.quantity ==
                              //                 null)
                              //             ? "Un-Quantifiable"
                              //             : viewModel.orderModel.quantity
                              //                 .toString(),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Base Price',
                              //         value: Constants.rupeeSign +
                              //             " ${(viewModel.orderModel.basePrice * viewModel.orderModel.quantity) / 100}",
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Service Charge',
                              //         value: Constants.rupeeSign +
                              //             " ${(viewModel.orderModel.serviceCharge * viewModel.orderModel.quantity) / 100}",
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Tax Charge',
                              //         value: Constants.rupeeSign +
                              //             " ${(viewModel.orderModel.basePrice + viewModel.orderModel.serviceCharge) * viewModel.orderModel.taxPercent * viewModel.orderModel.quantity / 10000}",
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Amount',
                              //         value: Constants.rupeeSign +
                              //             " ${(viewModel.orderModel.basePrice + viewModel.orderModel.serviceCharge) * viewModel.orderModel.taxPercent * viewModel.orderModel.quantity / 10000 + (viewModel.orderModel.serviceCharge * viewModel.orderModel.quantity) / 100 + (viewModel.orderModel.basePrice * viewModel.orderModel.quantity) / 100}",
                              //       ),
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //       (viewModel.orderModel.addons.length != 0)
                              //           ? ListView.builder(
                              //               shrinkWrap: true,
                              //               physics:
                              //                   NeverScrollableScrollPhysics(),
                              //               itemBuilder: (BuildContext context,
                              //                   int index) {
                              //                 return Column(
                              //                   children: [
                              //                     Padding(
                              //                       padding:
                              //                           const EdgeInsets.all(
                              //                               8.0),
                              //                       child: Container(
                              //                         width:
                              //                             MediaQuery.of(context)
                              //                                 .size
                              //                                 .width,
                              //                         decoration: BoxDecoration(
                              //                             color: Colors.white,
                              //                             borderRadius:
                              //                                 BorderRadius.all(
                              //                                     Radius
                              //                                         .circular(
                              //                                             10)),
                              //                             border: Border.all(
                              //                                 color: Colors
                              //                                     .tealAccent)),
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets
                              //                                   .all(8.0),
                              //                           child: Text(
                              //                             "ADD-ONS-" +
                              //                                 "${index + 1}",
                              //                             style: TextStyle(
                              //                                 color:
                              //                                     Colors.orange,
                              //                                 fontSize: 13,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .bold),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     Addons(
                              //                       serviceName: viewModel
                              //                           .orderModel
                              //                           .addons[index]
                              //                           .serviceName,
                              //                       taxCharge: viewModel
                              //                           .orderModel
                              //                           .addons[index]
                              //                           .addOnTaxCharge,
                              //                       basePrice: viewModel
                              //                           .orderModel
                              //                           .addons[index]
                              //                           .addOnBasePrice,
                              //                       serviceCharge: viewModel
                              //                           .orderModel
                              //                           .addons[index]
                              //                           .addOnServiceCharge,
                              //                       amount: viewModel.orderModel
                              //                           .addons[index].amount,
                              //                       // cashOnDelivery:
                              //                       //     widget.cashOnDelivery,
                              //                       quantity: viewModel
                              //                           .orderModel
                              //                           .addons[index]
                              //                           .quantity,
                              //                     ),
                              //                   ],
                              //                 );
                              //               },
                              //               itemCount: viewModel
                              //                   .orderModel.addons.length,
                              //             )
                              //           : SizedBox(),
                              //       Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Container(
                              //           width:
                              //               MediaQuery.of(context).size.width,
                              //           decoration: BoxDecoration(
                              //               color: Colors.white,
                              //               borderRadius: BorderRadius.all(
                              //                   Radius.circular(10)),
                              //               border: Border.all(
                              //                   color: Colors.tealAccent)),
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Text(
                              //               "PAYMENT DETAILS",
                              //               style: TextStyle(
                              //                   color: Colors.orange,
                              //                   fontSize: 13,
                              //                   fontWeight: FontWeight.bold),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Total Base Price',
                              //         value: Constants.rupeeSign +
                              //             " ${viewModel.orderModel.orderBasePrice / 100 + (viewModel.orderModel.totalAddonBasePrice / 100)}",
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Total Service Charge',
                              //         value: Constants.rupeeSign +
                              //             " ${viewModel.orderModel.orderServiceCharge / 100 + (viewModel.orderModel.totalAddonServiceCharge / 100)}",
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Total Tax Charges',
                              //         value: Constants.rupeeSign +
                              //             " ${viewModel.orderModel.orderTaxCharge / 100}",
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             16.0, 4, 16, 0),
                              //         child: Divider(
                              //           color: Colors.tealAccent,
                              //         ),
                              //       ),
                              //       Banner(
                              //         title: 'Discount',
                              //         value: "- " +
                              //             Constants.rupeeSign +
                              //             " ${viewModel.orderModel.orderDiscount / 100}",
                              //       ),
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Container(
                              //           width:
                              //               MediaQuery.of(context).size.width,
                              //           decoration: BoxDecoration(
                              //               color: Colors.white,
                              //               borderRadius: BorderRadius.all(
                              //                   Radius.circular(10)),
                              //               border: Border.all(
                              //                   color: Colors.tealAccent)),
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Row(
                              //               children: [
                              //                 Text(
                              //                   "TOTAL CHARGES",
                              //                   style: TextStyle(
                              //                       color: Colors.black,
                              //                       fontSize: 13,
                              //                       fontWeight:
                              //                           FontWeight.bold),
                              //                 ),
                              //                 Spacer(),
                              //                 Text(
                              //                   Constants.rupeeSign +
                              //                       " ${viewModel.orderModel.orderAmount / 100}",
                              //                   style: TextStyle(
                              //                       color: Colors.red,
                              //                       fontSize: 15,
                              //                       fontWeight:
                              //                           FontWeight.bold),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Row(
                              //           children: [
                              //             Spacer(),
                              //             (viewModel.orderModel
                              //                         .cashOnDelivery ==
                              //                     true)
                              //                 ? Text(
                              //                     "PAY ON DELIVERY",
                              //                     style: TextStyle(
                              //                         fontSize: 14,
                              //                         fontWeight:
                              //                             FontWeight.bold,
                              //                         color: Colors.red),
                              //                   )
                              //                 : Text(
                              //                     "ONLINE PAYMENT",
                              //                     style: TextStyle(
                              //                         fontSize: 14,
                              //                         fontWeight:
                              //                             FontWeight.bold,
                              //                         color: Colors.red),
                              //                   ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // Column(
                              //   children: [
                              //     Row(
                              //       children: [
                              //         Spacer(),
                              //         Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: InkWell(
                              //             child: GestureDetector(
                              //               onTap: () {
                              //                 _showRatingBar();
                              //               },
                              //               child: Container(
                              //                 color:
                              //                     Colors.yellow.withOpacity(.5),
                              //                 child: Center(
                              //                   child: Padding(
                              //                     padding:
                              //                         const EdgeInsets.all(8.0),
                              //                     child: Text(
                              //                       "RATE USER",
                              //                       style: TextStyle(
                              //                           color: Colors.red,
                              //                           fontSize: 15,
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: InkWell(
                              //             child: GestureDetector(
                              //               onTap: () {
                              //                 Navigator.pushReplacement(context,
                              //                     MaterialPageRoute(
                              //                         builder: (ctx) {
                              //                   return NavigationScreen();
                              //                 }));
                              //               },
                              //               child: Container(
                              //                 width: 70,
                              //                 color:
                              //                     Colors.yellow.withOpacity(.5),
                              //                 child: Center(
                              //                   child: Padding(
                              //                     padding:
                              //                         const EdgeInsets.all(8.0),
                              //                     child: Text(
                              //                       "DONE",
                              //                       style: TextStyle(
                              //                           color: Colors.red,
                              //                           fontSize: 15,
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // )
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
            // child:
            // CustomRating(
            //   userName: _bloc.latestViewModel.orderModel.userName,
            //   userID: widget.userID,
            // ),
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
            child: Text(
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
    // TODO: implement dispose
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
