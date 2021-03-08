import 'dart:developer';

import 'package:fixbee_partner/blocs/customize_service_bloc.dart';
import 'package:fixbee_partner/events/customize_service_event.dart';
import 'package:fixbee_partner/models/customize_service_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/service_banner.dart';
import 'package:fixbee_partner/ui/screens/add_services.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../Constants.dart';

class CustomizeService extends StatefulWidget {
  @override
  _CustomizeServiceState createState() => _CustomizeServiceState();
}

class _CustomizeServiceState extends State<CustomizeService> {
  CustomizeServiceBloc _bloc;
  bool showDeleteButton = false;

  @override
  void initState() {
    _bloc = CustomizeServiceBloc(CustomizeServiceModel());
    _bloc.fire(CustomizeServiceEvent.fetchSelectedServices);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColors.backgroundColor,
          automaticallyImplyLeading: false,
          title: Stack(
            children: <Widget>[
              Container(
                  decoration:
                      BoxDecoration(color: PrimaryColors.backgroundColor),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'CUSTOMIZE SERVICE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15)),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline_rounded,
                size: 50,
              ),
              onPressed: () {
                setState(() {
                  if (!showDeleteButton)
                    showDeleteButton = true;
                  else
                    showDeleteButton = false;
                });
              },
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
            ),
            SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              mini: false,
              elevation: 4,
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return AddServices();
                }));
                _bloc.fire(CustomizeServiceEvent.fetchSelectedServices);
              },
            ),
          ],
        ),
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return ListView(
            children: [
              Column(
                children: [
                  (viewModel.fetchingMyServices)
                      ? LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: PrimaryColors.backgroundColor,
                        )
                      :
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 12, 10, 10),
                    child: Row(
                      children: [
                        Text(
                          "SERVICES:",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.selectedServiceOptionModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ServiceBanner(
                              serviceName: viewModel
                                  .selectedServiceOptionModel[index]
                                  .serviceName,
                              showDeleteIcon: showDeleteButton,
                              deleteService: () {
                                _showJobDeletionDialog(
                                    viewModel.selectedServiceOptionModel[index]
                                        .serviceName,
                                    viewModel
                                        .selectedServiceOptionModel[index].id);
                              },
                            ),
                          ],
                        );
                      })

            ],
          );
        }),
      ),
    );
  }

  _showJobDeletionDialog(String serviceName, String serviceId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "Are you sure you want to remove service $serviceName?",
              maxLines: null,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: PrimaryColors.backgroundColor,
                  onPressed: () {
                    _bloc.fire(CustomizeServiceEvent.deleteSelectedService,
                        message: {'serviceId': '$serviceId'},
                        onHandled: (e, m) {
                      Navigator.pop(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "YES",
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: PrimaryColors.backgroundColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "NO",
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
