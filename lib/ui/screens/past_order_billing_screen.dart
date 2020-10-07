import 'dart:ui';

import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/ui/custom_widget/addon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../Constants.dart';

class PastOrderBillingScreen extends StatefulWidget {
  final String serviceName, status, address, userName, timeStamp, orderId;
  final bool cashOnDelivery;
  final int basePrice, serviceCharge, taxPercent, amount;
  final List<Service> addOns;

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
      this.addOns})
      : super(key: key);
  @override
  _PastOrderBillingScreenState createState() => _PastOrderBillingScreenState();
}

class _PastOrderBillingScreenState extends State<PastOrderBillingScreen> {
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
                    value: "${(widget.basePrice) / 100}",
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                    child: Divider(
                      color: Colors.tealAccent,
                    ),
                  ),
                  Banner(
                    title: 'Service Charge',
                    value: "${(widget.serviceCharge) / 100}",
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                    child: Divider(
                      color: Colors.tealAccent,
                    ),
                  ),
                  Banner(
                    title: 'Tax',
                    value:
                        '${widget.taxPercent * ((widget.basePrice + widget.serviceCharge) / 10000)}',
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
                          'Total (Inclusive of all taxes)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          "${(widget.amount) / 100}",
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
            (widget.addOns != null || widget.addOns.isEmpty)
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
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
