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
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants.dart';
import 'all_service_selection_screen.dart';

class CustomizeService extends StatefulWidget {
  @override
  _CustomizeServiceState createState() => _CustomizeServiceState();
}

class _CustomizeServiceState extends State<CustomizeService> {
  CustomizeServiceBloc _bloc;
  bool showDeleteButton = false;
  List<String> mySelectedOrderId = [];

  @override
  void initState() {
    _bloc = CustomizeServiceBloc(CustomizeServiceModel());

    _bloc.fire(CustomizeServiceEvent.fetchSelectedServices, onHandled: (e, m) {
      for (var i in m.selectedServiceOptionModel) {
        mySelectedOrderId.add(i.id);
      }
    });
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
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Row(
                  children: [
                    Text(
                      "Your ",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                    ),
                    SvgPicture.asset(
                      'assets/custom_icons/bucket.svg',
                      color: Theme.of(context).primaryColor,
                      height: 30,
                      width: 30,
                    ),
                  ],
                ),
              ),
              (viewModel.fetchingMyServices)
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: PrimaryColors.backgroundColor,
                    )
                  : SizedBox(),
              (viewModel.deletingSelectedService)
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: PrimaryColors.backgroundColor,
                    )
                  : SizedBox(),
              (viewModel.checkingAvailabilityForRemoval)
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: PrimaryColors.backgroundColor,
                    )
                  : SizedBox(),
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                        padding: EdgeInsets.only(bottom: 60),
                        itemCount: viewModel.selectedServiceOptionModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ServiceBanner(
                            serviceName: viewModel
                                .selectedServiceOptionModel[index].serviceName,
                            showDeleteIcon: showDeleteButton,
                            image: viewModel
                                .selectedServiceOptionModel[index].imageLink,
                            excerpt: viewModel
                                .selectedServiceOptionModel[index].excerpt,
                            deleteService: () async {
                              var value = await _showConfirmDialog(
                                  viewModel.selectedServiceOptionModel[index]
                                      .serviceName,
                                  viewModel
                                      .selectedServiceOptionModel[index].id);
                              if(value){
                                _bloc.fire(
                                    CustomizeServiceEvent.deleteSelectedService,
                                    message: {
                                      'serviceId':
                                      '${viewModel.selectedServiceOptionModel[index].id}'
                                    }, onHandled: (e, m) {
                                  if (m.isDeletedSuccessfully)
                                    _showMessageDialog('Deleted Successfully');
                                  else
                                    _showMessageDialog(m.errorMessage);
                                });
                              }
                            },
                          );
                        }),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: (viewModel.selectedServiceOptionModel.length != 0)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    _bloc.fire(
                                        CustomizeServiceEvent.checkAvailability,
                                        onHandled: (e, m) {
                                      if (m.availableForRemoval) {
                                        setState(() {
                                          if (!showDeleteButton)
                                            showDeleteButton = true;
                                          else
                                            showDeleteButton = false;
                                        });
                                      } else {
                                        _showMessageDialog(
                                            'You cannot remove services if you have an active order!');
                                      }
                                    });
                                  },
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Remove",
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                FloatingActionButton(
                                  mini: true,
                                  elevation: 4,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).canvasColor,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    bool addedNewService =
                                        await Navigator.push(context,
                                            MaterialPageRoute(builder: (ctx) {
                                      return AllServiceSelection(
                                        mySelectOrderId: mySelectedOrderId,
                                      );
                                    }));
                                    if (addedNewService ?? false)
                                      _bloc.fire(CustomizeServiceEvent
                                          .fetchSelectedServices);
                                  },
                                ),
                              ],
                            )
                          : SizedBox(),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  _showMessageDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: Theme.of(context).cardColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
            ),
          );
        });
  }

  _showConfirmDialog(String serviceName, String serviceId) {
    return showDialog(
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
                          "Are you sure you want to remove service $serviceName?",
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
                              Navigator.pop(context, false);
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
                                "Confirm",
                                style:
                                    TextStyle(color: PrimaryColors.yellowColor),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
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
