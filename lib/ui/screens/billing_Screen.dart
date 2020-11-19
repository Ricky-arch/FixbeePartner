import 'dart:ui';

import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/addon.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../Constants.dart';
import 'navigation_screen.dart';

class BillingScreen extends StatefulWidget {
  final String serviceName, status, address, userName, timeStamp, orderId, userID;
  final bool cashOnDelivery;
  final int basePrice, serviceCharge, taxPercent, amount;
  final List<int> addOnAmounts;
  final List<int> addOnServiceCharge;
  final List<int> addOnTaxPercent;
  final List<Service> addOns;
  const BillingScreen(
      {Key key,
      this.serviceName,
      this.status,
      this.address,
      this.userName,
      this.cashOnDelivery,
      this.basePrice,
      this.serviceCharge,
      this.taxPercent,
      this.amount,
      this.timeStamp,
      this.orderId,
      this.addOnAmounts,
      this.addOnServiceCharge,
      this.addOnTaxPercent,
      this.addOns, this.userID})
      : super(key: key);
  @override
  BillingScreenState createState() => BillingScreenState();
}

class BillingScreenState extends State<BillingScreen> {
  int bp, sc;
  double tax;
  double amount;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    amount = widget.amount.toDouble();
    for (var addOn in widget.addOns) {
      amount = amount + addOn.amount.toDouble();
    }



    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
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
                          Text(
                            "ORDER ID: ${widget.orderId.toUpperCase()}",
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
                      "SERVICE DETAILS",
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
                      title: 'User Name',
                      value: widget.userName,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Banner(
                      title: 'Service',
                      value: widget.serviceName,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Banner(
                      title: 'Address',
                      value: widget.address,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Banner(
                      title: 'Status',
                      value: widget.status,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Banner(
                      title: 'TimeStamp',
                      value: widget.timeStamp,
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.tealAccent)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "PAYMENT DETAILS",
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
                      title: 'Base Price',
                      value:
                          Constants.rupeeSign + " ${(widget.basePrice) / 100}",
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Banner(
                      title: 'Service Charge',
                      value: Constants.rupeeSign +
                          " ${(widget.serviceCharge) / 100}",
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Banner(
                      title: 'Tax',
                      value: Constants.rupeeSign +
                          (widget.taxPercent *
                                  ((widget.basePrice + widget.serviceCharge) /
                                      10000))
                              .toStringAsFixed(2),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Banner(
                      title: 'Quantity',
                      value: '4',
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total (Inclusive of taxes)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            Constants.rupeeSign +
                                " ${(widget.basePrice / 100) + (widget.serviceCharge / 100) + (widget.taxPercent * ((widget.basePrice + widget.serviceCharge) / 10000))}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Spacer(),
                          (widget.cashOnDelivery == true)
                              ? Text(
                                  "PAY ON DELIVERY",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )
                              : Text(
                                  "ONLINE PAYMENT",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              (widget.addOns.length != 0)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
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
                                    "ADD-ONS-" + "${index + 1}",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Addons(
                              quantity: 4,
                              serviceName: widget.addOns[index].serviceName,
                              taxPercent: widget.addOns[index].taxPercent,
                              basePrice: widget.addOns[index].basePrice,
                              serviceCharge: widget.addOns[index].serviceCharge,
                              amount: widget.addOns[index].amount,
                              cashOnDelivery: widget.cashOnDelivery,
                            ),
                          ],
                        );
                      },
                      itemCount: widget.addOns.length,
                    )
                  : SizedBox(),
              (widget.addOns.length == 0)
                  ? SizedBox()
                  : TotalChargesPanel(
                      bp: bp,
                      sc: sc,
                      amount: amount,
                      tax: tax,
                    ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: GestureDetector(
                            onTap: () {
                              _showRatingBar();
                            },
                            child: Container(
                              width: 110,
                              color: Colors.yellow.withOpacity(.5),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "RATE USER",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return NavigationScreen();
                              }));
                            },
                            child: Container(
                              width: 70,
                              color: Colors.yellow.withOpacity(.5),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "DONE",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
            child: CustomRatingWidget(
              userName: widget.userName,
              userID: widget.userID,
            ),
          );
        });
  }
  _showSnackBar(String value){
    final snackBar = new SnackBar(content: new Text("Don't forget to rate our user!"),
        backgroundColor: Colors.red);

    Scaffold.of(context).showSnackBar(snackBar);
  }
}

class TotalChargesPanel extends StatelessWidget {
  final int bp, sc;
  final double tax, amount;

  const TotalChargesPanel({Key key, this.bp, this.sc, this.tax, this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL CHARGES",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Constants.rupeeSign +
                        " " +
                        (amount / 100).toStringAsFixed(2),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
