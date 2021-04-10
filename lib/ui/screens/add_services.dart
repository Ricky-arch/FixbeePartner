import 'package:fixbee_partner/blocs/add_new_service_bloc.dart';
import 'package:fixbee_partner/events/add_new_service_event.dart';
import 'package:fixbee_partner/models/add_new_service_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/ui/custom_widget/add_new_service_banner.dart';
import 'package:fixbee_partner/utils/excerpt.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class AddServices extends StatefulWidget {
  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  AddNewServiceBloc _bloc;
  @override
  void initState() {
    _bloc = AddNewServiceBloc(AddNewServiceModel());
    _bloc.fire(AddNewServiceEvent.fetchServicesAvailableForMe);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: PrimaryColors.backgroundcolorlight,
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
                              text: 'ADD TO YOUR SKILL LIST',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            elevation: 4,
            onPressed: () {
              if (_bloc.latestViewModel.newSelectedServices.length == 0) {
                _showDialogForNoServiceSelected();
              } else {
                for (var i in _bloc.latestViewModel.newSelectedServices) {
                  print(i.serviceName.toString());
                }
                _showConfirmDialog();
              }
            },
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
          ),
          body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return (viewModel.loading)
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: PrimaryColors.backgroundColor,
                      )
                    : ListView(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: viewModel.availableServices.length,
                              itemBuilder: (BuildContext context, int index) {
                                String parentName = viewModel
                                    .availableServices[index].serviceName;
                                List<ServiceOptionModel> childServices =
                                    viewModel
                                        .availableServices[index].subServices;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 8, 8, 0),
                                      child: Container(
                                        child: Text(
                                          parentName.toUpperCase() + " :",
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Column(
                                        children: childServices.map((service) {
                                      var excerpt = service.excerpt;
                                      return AddNewServiceBanner(
                                        serviceName: service.serviceName,
                                        subService: service,
                                        excerpt: excerpt,
                                        onServiceChecked: (subService, value) {
                                          if (value) {
                                            viewModel.newSelectedServices
                                                .add(subService);
                                            _bloc.pushViewModel(viewModel);
                                          } else {
                                            viewModel.newSelectedServices
                                                .remove(subService);
                                            _bloc.pushViewModel(viewModel);
                                          }
                                        },
                                      );
                                    }).toList()),
                                  ],
                                );
                              }),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      );
              },
            );
          })),
    );
  }

  _showSelectedSkillDialogBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: PrimaryColors.backgroundColor,
                  onPressed: () {
                    _bloc.fire(AddNewServiceEvent.saveSelectedServices,
                        onHandled: (e, m) {
                      Navigator.pop(context);
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
            title: Text("Are you sure you want to add the selected skill?"),
          );
        });
  }

  _showDialogForNoServiceSelected() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(0),
            title: Text("No Service Selected!"),
            actions: [
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
                      "Close",
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  _showConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: PrimaryColors.backgroundColor,
            elevation: 2,
            insetPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          "Are you sure you want to add the selected skill?",
                          style: TextStyle(
                              color: PrimaryColors.whiteColor, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          RaisedButton(
                            color: PrimaryColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cancel",
                                style:
                                    TextStyle(color: PrimaryColors.yellowColor),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: 15,
                            child: Container(
                              color: PrimaryColors.yellowColor,
                            ),
                            width: 3,
                          ),
                          RaisedButton(
                            color: PrimaryColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Add",
                                style:
                                    TextStyle(color: PrimaryColors.yellowColor),
                              ),
                            ),
                            onPressed: () {
                              _bloc
                                  .fire(AddNewServiceEvent.saveSelectedServices,
                                      onHandled: (e, m) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
