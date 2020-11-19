import 'dart:ui';

import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/addon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../Constants.dart';

class PastOrderBillingScreen extends StatefulWidget {
  final String serviceName, status, address, userName, timeStamp, orderId;
  final bool cashOnDelivery;
  final int basePrice, serviceCharge, taxPercent, amount, quantity;
  final List<Service> addOns;
  final int orderAmount, orderServiceCharge, orderDiscount, orderTaxCharge, orderBasePrice;

  const PastOrderBillingScreen(
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
      this.addOns,
      this.quantity, this.orderAmount, this.orderServiceCharge, this.orderDiscount, this.orderTaxCharge, this.orderBasePrice})
      : super(key: key);
  @override
  _PastOrderBillingScreenState createState() => _PastOrderBillingScreenState();
}

class _PastOrderBillingScreenState extends State<PastOrderBillingScreen> {
  int bp, sc;
  double tax, amount;
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
                    title: 'User',
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
                    "ORDER PAYMENT DETAILS",
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
                    title: 'Quantity',
                    value: (widget.quantity == null)
                        ? "Un-Quantifiable"
                        : widget.quantity.toString(),
                  ),
                  Banner(
                    title: 'Base Price',
                    value: Constants.rupeeSign + " ${(widget.orderBasePrice) / 100}",
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
                        " ${(widget.orderServiceCharge) / 100}",
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                    child: Divider(
                      color: Colors.tealAccent,
                    ),
                  ),
                  Banner(
                    title: 'Discount',
                    value: "- "+Constants.rupeeSign + " ${(widget.orderDiscount) / 100}",
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
                        (widget.orderTaxCharge/100)
                            .toStringAsFixed(2),
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
                          'Total (Inclusive of all taxes)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          Constants.rupeeSign +
                              (widget.orderAmount/100).toString(),
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
                                  border: Border.all(color: Colors.tealAccent)),
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
                    amount: widget.amount.toDouble(),
                    tax: tax,
                  ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 70,
                        color: Colors.yellow.withOpacity(.5),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "BACK",
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
            )
          ],
        ),
      ),
    );
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
