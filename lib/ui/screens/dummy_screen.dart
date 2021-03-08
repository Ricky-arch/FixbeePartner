import 'dart:developer';
import "package:collection/collection.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fixbee_partner/blocs/all_service_bloc.dart';
import 'package:fixbee_partner/events/all_services_event.dart';
import 'package:fixbee_partner/ui/custom_widget/date_picker.dart';
import 'package:fixbee_partner/ui/custom_widget/order_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fixbee_partner/models/all_Service.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';

import '../../Constants.dart';

class Dummy extends StatefulWidget {
  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  bool enabled = false;
  String text;

  @override
  void initState() {
    var data = [
      {'title': 'Child 1 of A', 'parent': 'A', 'Grand': 'D'},
      {'title': 'Child 2 of A', 'parent': 'A', 'Grand': 'C'},
      {'title': 'Child 3 of A', 'parent': 'A', 'Grand': 'C'},
      {'title': 'Child 1 of B', 'parent': 'B', 'Grand': 'C'},
      {'title': 'Child 2 of B', 'parent': 'B', 'Grand': 'D'}
    ];
    List<Map<dynamic, dynamic>> items = [];
    var parentMap = groupBy(data, (obj) => obj['parent']);
    parentMap.forEach((key, value) {
      var grandMap = groupBy(value, (obj) => obj['Grand']);

      items.add(grandMap);
    });
    // print(items);
    setState(() {
      text = items.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColors.whiteColor,
      body: Center(
          child: OrderWidget(
            orderId: '123456',
            userPhone: '1234567890',


            orderMode: 'COD',
            orderAddress: 'Nagerjala, Agartala',
            serviceName: 'Good Service',
            userName: 'Saurav Sutradhar',
          )),
    );
  }
}
