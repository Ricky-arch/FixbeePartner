import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/service_selection_events.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class SetServicesBloc extends Bloc<ServiceSelectionEvents, ServiceOptionModels>
    with Trackable<ServiceSelectionEvents, ServiceOptionModels> {
  SetServicesBloc(ServiceOptionModels genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<ServiceOptionModels> mapEventToViewModel(
      ServiceSelectionEvents event, Map<String, dynamic> message) async {
    if (event == ServiceSelectionEvents.fetchAvailableServices) {
      return await fetchAvailableServices();
    } else if (event == ServiceSelectionEvents.saveSelectedServices) {
      return await saveSelectedServices();
    }
    return latestViewModel;
  }

  Future<ServiceOptionModels> fetchAvailableServices() async {
    String query = '''{
  Services(Cannonical:true){
    ID
    Name
    Image{
      id
    }
    Children{
      ID
      Name
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List<ServiceOptionModel> models = [];
    List services = response['Services'];
    services.forEach((service) {
      ServiceOptionModel serviceModel = ServiceOptionModel();

      List subServices = service['Children'];
      subServices.forEach((subService) {
        ServiceOptionModel child = ServiceOptionModel();
        child.serviceName = subService['Name'];
        child.id = subService['ID'];
        serviceModel.subServices.add(child);
      });
      serviceModel.serviceName = service['Name'];
      serviceModel.id = service['ID'];
      serviceModel.imageLink =
          'https://images.pexels.com/photos/3706707/pexels-photo-3706707.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

      models.add(serviceModel);
    });

    return ServiceOptionModels()..serviceOptions = models;
  }

  Future<ServiceOptionModels> saveSelectedServices() async {
    String query = '''mutation{
  Update(input:{AddServices:${latestViewModel.selectedServices.map((service) {
      return '"${service.id}"';
    }).toList()}}){
    ... on Bee{
      Name{
        Firstname
      }
    }
  }
}''';
    print(query);
    await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  @override
  ServiceOptionModels setTrackingFlag(
      ServiceSelectionEvents event, bool trackFlag, Map message) {
    if (event == ServiceSelectionEvents.fetchAvailableServices) {
      latestViewModel.fetching = trackFlag;
    } else if (event == ServiceSelectionEvents.saveSelectedServices) {
      latestViewModel.saving = trackFlag;
    }
    return latestViewModel;
  }
}
