import 'package:fixbee_partner/blocs/add_new_service_bloc.dart';
import 'package:fixbee_partner/events/add_new_service_event.dart';
import 'package:fixbee_partner/models/add_new_service_model.dart';
import 'package:fixbee_partner/ui/custom_widget/add_new_service_banner.dart';
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
    return Scaffold(
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
          elevation: 4,
          onPressed: () {
            if (_bloc.latestViewModel.newSelectedServices.length == 0) {
              _showDialogForNoServiceSelected();
            } else {
              for (var i in _bloc.latestViewModel.newSelectedServices) {
                print(i.serviceName.toString());
              }
              _showSelectedSkillDialogBox();
            }
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
        ),
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ListView(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.allServicesAvailableForMe.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (index == 0)
                                ? Padding(
                              padding:
                              const EdgeInsets.fromLTRB(12.0, 8, 8, 0),
                              child: Container(
                                child: Text(
                                  viewModel.allServicesAvailableForMe[index]
                                      .parentName
                                      .toUpperCase() +
                                      " :",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                                : SizedBox(),
                            (index > 0 &&
                                viewModel.allServicesAvailableForMe[index]
                                    .parentName !=
                                    viewModel
                                        .allServicesAvailableForMe[index - 1]
                                        .parentName)
                                ? Padding(
                              padding:
                              const EdgeInsets.fromLTRB(12.0, 8, 8, 0),
                              child: Container(
                                child: Text(
                                  viewModel.allServicesAvailableForMe[index]
                                      .parentName
                                      .toUpperCase() +
                                      " :",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                                : SizedBox(),
                            AddNewServiceBanner(
                              serviceName: viewModel
                                  .allServicesAvailableForMe[index].serviceName,
                              subService:
                              viewModel.allServicesAvailableForMe[index],
                              onServiceChecked: (subService, value) {
                                if (value) {
                                  viewModel.newSelectedServices.add(subService);
                                  _bloc.pushViewModel(viewModel);
                                } else {
                                  viewModel.newSelectedServices.remove(subService);
                                  _bloc.pushViewModel(viewModel);
                                }
                              },
                            ),
                          ],
                        );
                      })
                ],
              );
            },
          );
        }));
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
}
