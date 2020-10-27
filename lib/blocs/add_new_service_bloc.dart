import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/add_new_service_event.dart';
import 'package:fixbee_partner/models/add_new_service_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class AddNewServiceBloc extends Bloc<AddNewServiceEvent, AddNewServiceModel> {
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
    Parent{
      Name
      Image{
        id
      }
    }
  }
}''';
    Map responseAll = await CustomGraphQLClient.instance.query(queryAll);
    List<ServiceOptionModel> all = [];

    List allServices = responseAll['Services'];
    List mine = response['Me']['Services'];
    allServices.removeWhere((e) {
      return ((String id, List<dynamic> mine) {
        for (var i in mine) {
          if (i['ID'] == id) {
            mine.remove(i);
            return true;
          }
        }
        return false;
      })(e['ID'], mine);
    });
    for (var service in allServices) {
      ServiceOptionModel s = ServiceOptionModel();
      s.id = service['ID'];
      s.serviceName = service['Name'];
      s.parentName = service['Parent']['Name'];
      s.imageLink = service['Parent']['Image']['id'];
      all.add(s);
    }

    return latestViewModel
      ..allServicesAvailableForMe = all
      ..numberOfUnselectedServices = all.length;
  }

  Future<AddNewServiceModel> saveSelectedServices() async {
    String query = '''mutation{
  Update(input:{AddServices:${latestViewModel.newSelectedServices.map((service) {
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
}
