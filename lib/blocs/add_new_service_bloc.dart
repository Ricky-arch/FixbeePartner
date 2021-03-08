import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/add_new_service_event.dart';
import 'package:fixbee_partner/models/add_new_service_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import "package:collection/collection.dart";
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class AddNewServiceBloc extends Bloc<AddNewServiceEvent, AddNewServiceModel>
    with Trackable<AddNewServiceEvent, AddNewServiceModel> {
  AddNewServiceBloc(AddNewServiceModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<AddNewServiceModel> mapEventToViewModel(
      AddNewServiceEvent event, Map<String, dynamic> message) async {
    if (event == AddNewServiceEvent.fetchServicesAvailableForMe) {
      return await fetchServicesAvailableForMe();
    } else if (event == AddNewServiceEvent.saveSelectedServices) {
      return await saveSelectedServices();
    }
    return latestViewModel;
  }

  Future<AddNewServiceModel> fetchServicesAvailableForMe() async {
    String query = '''{
  availableServices{
    name
    id
    priceable
    parent{
      name
    }
  }
}
''';
    Map response = await CustomGraphQLClient.instance.query(query);
    var serviceMap =
        groupBy(response['availableServices'], (obj) => obj['parent']['name']);
    print(serviceMap);
    List<ServiceOptionModel> servicesList = [];
    serviceMap.forEach((key, value) {
      ServiceOptionModel parentService = ServiceOptionModel();
      parentService.serviceName = key;
      List<ServiceOptionModel> childServiceList = [];
      value.forEach((value) {
        ServiceOptionModel childService = ServiceOptionModel();
        childService.serviceName = value['name'];
        childService.id = value['id'];
        childService.priceable = value['priceable'];
        childServiceList.add(childService);
      });
      parentService.subServices = childServiceList;
      servicesList.add(parentService);
    });
    return latestViewModel..availableServices = servicesList;
  }

  Future<AddNewServiceModel> saveSelectedServices() async {
    String query = '''
    mutation {
  update(input: {
    addServices: ${latestViewModel.newSelectedServices.map((service) {
      return '"${service.id}"';
    }).toList()}
  }){
    services{
      id
      name
    }
  }
}
    ''';

    print(query);
    await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  @override
  AddNewServiceModel setTrackingFlag(
      AddNewServiceEvent event, bool trackFlag, Map message) {
    if (event == AddNewServiceEvent.fetchServicesAvailableForMe)
      latestViewModel..loading = trackFlag;
    return latestViewModel;
  }
}
