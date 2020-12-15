import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/set_services_bloc.dart';
import 'package:fixbee_partner/events/service_selection_events.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/ui/custom_widget/services.dart';
import 'package:fixbee_partner/ui/custom_widget/skillSetBottomSheet.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import '../../data_store.dart';
import 'home.dart';

class ServiceSelectionScreen extends StatefulWidget {
  @override
  _ServiceSelectionScreenState createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  SetServicesBloc _bloc;

  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _bloc = SetServicesBloc(ServiceOptionModels());
    _bloc.fire(ServiceSelectionEvents.fetchAvailableServices);
  }

  @override
  void dispose() {
    _bloc?.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: PrimaryColors.backgroundColor,
              automaticallyImplyLeading: false,
              title: Stack(
                children: <Widget>[
                  Container(
                      decoration:
                          BoxDecoration(color: PrimaryColors.backgroundColor),
                      child: Row(
                        children: <Widget>[
                          Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: SvgPicture.asset(
                                    "assets/logo/bee_outline.svg",
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'AVAILABLE SERVICES',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            floatingActionButton: viewModel.selectedServices.length == 0
                ? SizedBox()
                : FloatingActionButton.extended(
                    backgroundColor: PrimaryColors.backgroundColor,
                    label: Text("ADD"),
                    onPressed: () {
                      _bloc.fire(ServiceSelectionEvents.saveSelectedServices,
                          onHandled: (e, m) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigationScreen())).then((value){
                                  if(value!=null && value =='from_nav')
                                    Navigator.pop(context);
                        });
                      });
                    },
                  ),
            backgroundColor: Color(0xfff6f6fb),
            body: viewModel.fetching || viewModel.saving
                ? Center(child: CircularProgressIndicator())
                : Services(
                    viewModel.serviceOptions,
                    onServiceSelected: (subServices) {
                      showModalBottomSheet(
                        isDismissible: false,
                        context: ctx,
                        builder: (ctx) {
                          return SkillSetBottomSheet(
                            onNext: () {
                              Navigator.pop(ctx);
                            },
                            subServices: subServices,
                            onServiceChecked: (subService, value) {
                              if (value) {
                                viewModel.selectedServices.add(subService);
                                _bloc.pushViewModel(viewModel);
                              } else {
                                viewModel.selectedServices.remove(subService);
                                _bloc.pushViewModel(viewModel);
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      );
    });
  }
}
