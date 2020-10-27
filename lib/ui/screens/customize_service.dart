import 'package:fixbee_partner/blocs/customize_service_bloc.dart';
import 'package:fixbee_partner/events/customize_service_event.dart';
import 'package:fixbee_partner/models/customize_service_model.dart';
import 'package:fixbee_partner/ui/custom_widget/service_banner.dart';
import 'package:fixbee_partner/ui/screens/add_services.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColors.backgroundColor,
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: PrimaryColors.backgroundColor),
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
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return AddServices();
                            }));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            color: Colors.orangeAccent.withOpacity(.5),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "ADD",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!showDeleteButton)
                                showDeleteButton = true;
                              else
                                showDeleteButton = false;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            color: Colors.orangeAccent.withOpacity(.5),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  (!showDeleteButton) ? "REMOVE" : "CANCEL",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 2, 10, 10),
                  child: Row(
                    children: [
                      Text(
                        "SERVICES:",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (viewModel.fetchSelectedServices)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: viewModel.selectedServiceOptionModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ServiceBanner(
                            serviceName: viewModel
                                .selectedServiceOptionModel[index].serviceName,
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
                : CircularProgressIndicator()
          ],
        );
      }),
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
