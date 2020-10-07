import 'package:flutter/material.dart';

class Addons extends StatelessWidget {
  final String serviceName;
  final int basePrice;
  final int serviceCharge;
  final int taxPercent;
  final int amount;
  final int quantity;
  final bool cashOnDelivery;
  const Addons(
      {Key key,
        this.serviceName,
        this.basePrice,
        this.serviceCharge,
        this.taxPercent,
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
            title: 'Service Name',
            value: "$serviceName",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Base Price',
            value: "${(basePrice) / 100}",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Service Charge',
            value: "${(serviceCharge) / 100}",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Tax',
            value: '$taxPercent',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
            child: Divider(
              color: Colors.tealAccent,
            ),
          ),
          Banner(
            title: 'Quantity',
            value: quantity.toString(),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  "${(amount) / 100}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                (cashOnDelivery == true)
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
          ),
        ],
      ),
    );
  }
}
