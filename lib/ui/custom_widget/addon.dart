import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';

class Addons extends StatelessWidget {
  final String serviceName;
  final int basePrice;
  final int serviceCharge;
  final int taxCharge;
  final int amount;
  final int quantity;
  final bool cashOnDelivery;

  const Addons(
      {Key key,
      this.serviceName,
      this.basePrice,
      this.serviceCharge,
      this.taxCharge,
      this.amount,
      this.quantity,
      this.cashOnDelivery})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Banner(
            title: 'Service',
            value: "$serviceName",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Quantity',
            value: (quantity != null) ? quantity.toString() : "Unquantifiable",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Base Price',
            value: Constants.rupeeSign + " ${(basePrice) / 100}",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Service Charge',
            value: Constants.rupeeSign + " ${(serviceCharge) / 100}",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Tax Charge',
            value: Constants.rupeeSign +
                taxCharge
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
                  'Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  Constants.rupeeSign + " ${(amount) / 100}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
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
