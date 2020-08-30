import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/customize_service_event.dart';
import 'package:fixbee_partner/models/customize_service_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class CustomizeServiceBloc
    extends Bloc<CustomizeServiceEvent, CustomizeServiceModel> {
  CustomizeServiceBloc(CustomizeServiceModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<CustomizeServiceModel> mapEventToViewModel(
      CustomizeServiceEvent event, Map<String, dynamic> message) async {
    if (event == CustomizeServiceEvent.fetchSelectedServices)
      return await fetchSelectedServices();

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
    return latestViewModel..selectedServiceOptionModel = selectedService;
  }
}
