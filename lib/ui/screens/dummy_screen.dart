import 'dart:developer';

import 'package:fixbee_partner/blocs/all_service_bloc.dart';
import 'package:fixbee_partner/events/all_services_event.dart';
import 'package:flutter/material.dart';

import 'package:fixbee_partner/models/all_Service.dart';
import 'package:hive/hive.dart';

class Dummy extends StatefulWidget {
  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  String code = "";
  AllServiceBloc _bloc;

  List gS = [];
  Box SERVICE;
  openHive() async {
    SERVICE = Hive.box("SERVICE");
  }

  @override
  void initState() {
    _bloc = AllServiceBloc(AllService());
    _bloc.openHive();
    _bloc.fire(AllServicesEvent.fetchTreeService, onHandled: (e, m) {
      openHive();
      SERVICE.add('GET');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      log(SERVICE.values.toString(), name:"ppp");
      return (viewModel.fetching)
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: 1,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Container(
                //       child: Padding(
                //         padding: EdgeInsets.all(12),
                //         child: Text(SERVICE.getAt(0)),
                //       ),
                //     );
                //   },
                // )
              ],
            );
    }));
  }
}
