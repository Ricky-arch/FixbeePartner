import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/custom_widget/banner_panel.dart';
import 'package:fixbee_partner/ui/custom_widget/order_widget.dart';
import 'package:flutter/material.dart';

class OrderNotification extends StatefulWidget {
  @override
  _OrderNotificationState createState() => _OrderNotificationState();
}

class _OrderNotificationState extends State<OrderNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
             // margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "YOUR ORDERS",
                style: TextStyle(
                    color: PrimaryColors.yellowColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            OrderWidget(
              userName: 'Saurav Sutradhar',
              serviceName:
                  'Bulb installation combo for iiving room and bed room',
              confirm: () {},
              decline: () {},
              orderAddress:
                  'Nagerjala, Near Jahar Bridge, Agartala, Tripura (west).',
              orderMode: 'COD',
              userPhone: '8787300192',
            ),
            OrderWidget(
              userName: 'Saurav Sutradhar',
              serviceName:
              'Bulb installation combo for iiving room and bed room',
              confirm: () {},
              decline: () {},
              orderAddress:
              'Nagerjala, Near Jahar Bridge, Agartala, Tripura (west).',
              orderMode: 'COD',
              userPhone: '8787300192',
            ),
            OrderWidget(
              userName: 'Saurav Sutradhar',
              serviceName:
              'Bulb installation combo for iiving room and bed room',
              confirm: () {},
              decline: () {},
              orderAddress:
              'Nagerjala, Near Jahar Bridge, Agartala, Tripura (west).',
              orderMode: 'COD',
              userPhone: '8787300192',
            ),
            OrderWidget(
              userName: 'Saurav Sutradhar',
              serviceName:
              'Bulb installation combo for iiving room and bed room',
              confirm: () {},
              decline: () {},
              orderAddress:
              'Nagerjala, Near Jahar Bridge, Agartala, Tripura (west).',
              orderMode: 'COD',
              userPhone: '8787300192',
            ),
            OrderWidget(
              userName: 'Saurav Sutradhar',
              serviceName:
              'Bulb installation combo for iiving room and bed room',
              confirm: () {},
              decline: () {},
              orderAddress:
              'Nagerjala, Near Jahar Bridge, Agartala, Tripura (west).',
              orderMode: 'COD',
              userPhone: '8787300192',
            ),
            OrderWidget(
              userName: 'Saurav Sutradhar',
              serviceName:
              'Bulb installation combo for iiving room and bed room',
              confirm: () {},
              decline: () {},
              orderAddress:
              'Nagerjala, Near Jahar Bridge, Agartala, Tripura (west).',
              orderMode: 'COD',
              userPhone: '8787300192',
            ),

          ],
        ),
      ),
    );
  }
}
