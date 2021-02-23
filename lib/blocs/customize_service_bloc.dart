import 'dart:developer';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/customize_service_event.dart';
import 'package:fixbee_partner/models/customize_service_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class CustomizeServiceBloc
    extends Bloc<CustomizeServiceEvent, CustomizeServiceModel>
    with Trackable<CustomizeServiceEvent, CustomizeServiceModel> {
  CustomizeServiceBloc(CustomizeServiceModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<CustomizeServiceModel> mapEventToViewModel(
      CustomizeServiceEvent event, Map<String, dynamic> message) async {
    if (event == CustomizeServiceEvent.fetchSelectedServices)
      return await fetchSelectedServices();
    if (event == CustomizeServiceEvent.deleteSelectedService)
      return await deleteSelectedService(message);
    if (event == CustomizeServiceEvent.fetchAvailableServices)
      return await fetchAvailableServices();
    return latestViewModel;
  }

  Future<CustomizeServiceModel> fetchSelectedServices() async {
    String query = '''{
      profile{
        services{
          id
    	    name
        }
      }
    }''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List<ServiceOptionModel> selectedService = [];

    List services = response['profile']['services'];

    services.forEach((service) {
      if (service != null) {
        ServiceOptionModel eachService = ServiceOptionModel();
        eachService.serviceName = service['name'];
        eachService.id = service['id'];
        selectedService.add(eachService);
      }
    });

    return latestViewModel
      ..selectedServiceOptionModel = selectedService
      ..numberOfSelectedServices = services.length;
  }

  @override
  CustomizeServiceModel setTrackingFlag(
      CustomizeServiceEvent event, bool trackFlag, Map message) {
    if (event == CustomizeServiceEvent.fetchSelectedServices)
      latestViewModel..fetchSelectedServices = trackFlag;

    return latestViewModel;
  }

  Future<CustomizeServiceModel> deleteSelectedService(
      Map<String, dynamic> message) async {
    String id = message['serviceId'];

    String query = '''mutation {
        update(input: {
          removeServices:["$id"]
        }){
        services{
          id
          name
        }
      }
    }''';
    try {
      await CustomGraphQLClient.instance.mutate(query);

      String query2 = '''{
        profile{
          services{
              id
    	        name
            } 
          }
       }''';
      Map response = await CustomGraphQLClient.instance.query(query2);
      List<ServiceOptionModel> selectedService = [];
      List services = response['profile']['services'];
      services.forEach((service) {
        ServiceOptionModel eachService = ServiceOptionModel();
        if (service != null) {
          eachService.serviceName = service['name'];
          eachService.id = service['id'];
          selectedService.add(eachService);
        }
      });
      return latestViewModel
        ..selectedServiceOptionModel = selectedService
        ..numberOfSelectedServices = services.length;
    } catch (e) {
      print(e);
    }
    return latestViewModel;
  }

  Future<CustomizeServiceModel> fetchAvailableServices() async {
    return latestViewModel;
  }
}
