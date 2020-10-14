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
    String query = '''{Me{
  ...on Bee{
   Services{
    Name
    ID
  }
  }
}}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List<ServiceOptionModel> selectedService = [];

    List services = response['Me']['Services'];

    services.forEach((service) {
      ServiceOptionModel eachService = ServiceOptionModel();
      eachService.serviceName = service['Name'];
      eachService.id = service['ID'];
      selectedService.add(eachService);
    });
    print("SSL" + services.length.toString());
    return latestViewModel
      ..selectedServiceOptionModel = selectedService
      ..numberOfSelectedServices = services.length;
  }

  @override
  CustomizeServiceModel setTrackingFlag(
      CustomizeServiceEvent event, bool trackFlag, Map message) {
    if (event == CustomizeServiceEvent.fetchSelectedServices)
      latestViewModel..fetchSelectedServices = true;
    return latestViewModel;
  }

  Future<CustomizeServiceModel> deleteSelectedService(
      Map<String, dynamic> message) async {
    String id = message['serviceId'];

    String query = '''mutation{
  Update(input:{RemoveService:"$id"}){
    ...on Bee{
      ID
    }
  }
}''';
    await CustomGraphQLClient.instance.mutate(query);

    String query2 = '''{Me{
  ...on Bee{
   Services{
    Name
    ID
  }
  }
}}''';
    Map response = await CustomGraphQLClient.instance.query(query2);
    List<ServiceOptionModel> selectedService = [];

    List services = response['Me']['Services'];

    services.forEach((service) {
      ServiceOptionModel eachService = ServiceOptionModel();
      eachService.serviceName = service['Name'];
      eachService.id = service['ID'];
      selectedService.add(eachService);
    });
    return latestViewModel
      ..selectedServiceOptionModel = selectedService
      ..numberOfSelectedServices = services.length;
  }

  Future<CustomizeServiceModel> fetchAvailableServices() async {
    String query = '''{Me{
  ...on Bee{
   Services{
    Name
    ID
  }
  }
}}''';
    Map response = await CustomGraphQLClient.instance.query(query);

    String queryAll = '''{
  Services(Cannonical:false){
    ID
    Name
  }
}''';

    Map responseAll = await CustomGraphQLClient.instance.query(queryAll);

    List all = responseAll['Services'];
    List mine = response['Me']['Services'];

    List filtered = [];

    all.removeWhere(
      (element) {
        return mine.contains(element);
      },
    );

    return latestViewModel;
  }
}
