import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/all_services_event.dart';
import 'package:fixbee_partner/models/all_Service.dart';

import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:hive/hive.dart';
import '../Constants.dart';

class AllServiceBloc extends Bloc<AllServicesEvent, AllService>
    with Trackable<AllServicesEvent, AllService> {
  AllServiceBloc(AllService genesisViewModel) : super(genesisViewModel);

  Box SERVICE;
  static Map<String, List<ServiceOptionModel>> serviceCache = {};
  openHive() async {
    await Hive.openBox("SERVICE");
    SERVICE = Hive.box("SERVICE");
  }

  @override
  Future<AllService> mapEventToViewModel(
      AllServicesEvent event, Map<String, dynamic> message) async {
    if (event == AllServicesEvent.fetchTreeService) {
      return await fetchGrand();
    } else if (event == AllServicesEvent.fetchParentService) {
      return await fetchParentService(message);
    } else if (event == AllServicesEvent.setCheckBox) {
      return await setCheckBox(message);
    } else if (event == AllServicesEvent.fetchChildServices) {
      return await fetchChildService(message);
    } else if (event == AllServicesEvent.saveSelectedServices) {
      return await saveSelectedServices();
    }
    return latestViewModel;
  }

  Future<AllService> fetchGrand() async {
    String query = '''
    {
  Services(Cannonical: true) {
    ID
    Name
    Image {
      id
    }
  }
}
    ''';

    Map response = await CustomGraphQLClient.instance.query(query);
    List<ServiceOptionModel> model = [];

    List services = response['Services'];
    services.forEach((service) {
      ServiceOptionModel grandService = ServiceOptionModel();

      grandService.serviceName = service['Name'];
      grandService.id = service['ID'];
      if(service['Image']['id']!=null)
      grandService.imageLink =
          "${EndPoints.DOCUMENT}?id=${service['Image']['id']}";

      model.add(grandService);
    });

    //SERVICE.put('GS',los);
    return latestViewModel..allAvailableServices = model;
  }

  @override
  AllService setTrackingFlag(
      AllServicesEvent event, bool trackFlag, Map message) {
    if (event == AllServicesEvent.fetchTreeService)
      latestViewModel..fetching = trackFlag;
    if (event == AllServicesEvent.fetchParentService)
      latestViewModel
        ..fetchingParent = trackFlag
        ..selectedServiceID = message['ID'];
    if (event == AllServicesEvent.setCheckBox) {
      latestViewModel..selectedParentId = message['ID'];
    }
    return latestViewModel;
  }

  Future<AllService> fetchParentService(Map<String, dynamic> message) async {
    String grandID = message['ID'];
    if (serviceCache.containsKey(grandID))
      return latestViewModel..parentServices = serviceCache[grandID];
    String query = '''
    {
  Service(_id: "$grandID") {
    Children {
      ID
      Name
       Pricing{
        Priceable
      }
      Image{
        id
      }
    }
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List<ServiceOptionModel> parentServices = [];
    List parent = response['Service']['Children'];
    parent.forEach((parent) {
      ServiceOptionModel parentService = ServiceOptionModel();
      parentService.id = parent['ID'];
      parentService.serviceName = parent['Name'];
      if(parent['Image']['id'] != null)
          parentService.imageLink =
              "${EndPoints.DOCUMENT}?id=${parent['Image']['id']}";
      parentService.priceable = parent['Pricing']['Priceable'];
      parentServices.add(parentService);
    });
    serviceCache[grandID] = parentServices;
    return latestViewModel..parentServices = parentServices;
  }

  Future<AllService> setCheckBox(Map<String, dynamic> message) async {
    latestViewModel..selectedParentId = message['ID'];
    return latestViewModel;
  }

  Future<AllService> fetchChildService(Map<String, dynamic> message) async {
    String parentId = message['ID'];
    if (serviceCache.containsKey(parentId)) {
      return latestViewModel..childServices = serviceCache[parentId];
    }
    String query = '''{
  Service(_id: "$parentId") {
    Children {
      ID
      Name
      Image {
        id
      }
    }
  }
}
''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List children = response['Service']['Children'];
    List<ServiceOptionModel> childServices = [];
    children.forEach((child) {
      ServiceOptionModel c = ServiceOptionModel();
      c.id = child['ID'];
      c.serviceName = child['Name'];
      if(child['Image']['id']!=null)
      c.imageLink = "${EndPoints.DOCUMENT}?id=${child['Image']['id']}";
      childServices.add(c);
    });
    serviceCache[parentId] = childServices;
    return latestViewModel..childServices = childServices;
  }

  Future<AllService> saveSelectedServices() async {
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
}
