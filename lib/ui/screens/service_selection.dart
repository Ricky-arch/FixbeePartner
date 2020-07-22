import 'package:fixbee_partner/blocs/set_services_bloc.dart';
import 'package:fixbee_partner/events/service_selection_events.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/ui/custom_widget/services.dart';
import 'package:fixbee_partner/ui/custom_widget/skillSetBottomSheet.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class ServiceSelectionScreen extends StatefulWidget {
  @override
  _ServiceSelectionScreenState createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  SetServicesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SetServicesBloc(ServiceOptionModels());
    _bloc.fire(ServiceSelectionEvents.fetchAvailableServices);
//    _genesisParcel = ServiceModels();
//    _bloc = ServiceSelectionBloc(_genesisParcel);
//    _bloc.feedEvent(ServiceSelectionEvents.fetchAvailableServices);
  }

  @override
  void dispose() {
    _bloc?.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return Scaffold(
        floatingActionButton: viewModel.selectedServices.length == 0
            ? SizedBox()
            : FloatingActionButton.extended(
                backgroundColor: Colors.orange,
                label: Text("View All"),
                onPressed: () {
                  _bloc.fire(ServiceSelectionEvents.saveSelectedServices,
                      onHandled: (e, m) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigationScreen()));
                  });
                },
              ),
        backgroundColor: Color(0xfff6f6fb),
        body: viewModel.fetching || viewModel.saving
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Services(
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
      );
    });
  }
}
