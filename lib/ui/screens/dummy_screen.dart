import 'dart:developer';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fixbee_partner/blocs/all_service_bloc.dart';
import 'package:fixbee_partner/events/all_services_event.dart';
import 'package:fixbee_partner/ui/custom_widget/date_picker.dart';
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


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
