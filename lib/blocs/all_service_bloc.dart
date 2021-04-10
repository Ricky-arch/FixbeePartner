import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/all_services_event.dart';
import 'package:fixbee_partner/models/all_Service.dart';

import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:fixbee_partner/utils/excerpt.dart';
import 'package:hive/hive.dart';
import '../Constants.dart';

class AllServiceBloc extends Bloc<AllServicesEvent, AllService>
    with Trackable<AllServicesEvent, AllService> {
  List<String> mySelectedServiceList;

  AllServiceBloc(AllService genesisViewModel, {this.mySelectedServiceList})
      : super(genesisViewModel);

  static Map<String, List<ServiceOptionModel>> serviceCache = {};

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
  services(skip:0, limit: 0) {
    id
    name
    excerpt
    image
  }
}
    ''';
    Map response;
    try {
      response = await CustomGraphQLClient.instance.query(query);
      List<ServiceOptionModel> model = [];

      List services = response['services'];
      services.forEach((service) {
        if (service != null) {
          ServiceOptionModel grandService = ServiceOptionModel();
          grandService.serviceName = service['name'];
          grandService.id = service['id'];
          grandService.rawExcerpt = service['excerpt'] ?? '';

          grandService.excerpt = Excerpt(service['excerpt']);
          if (service['image'] != null)
            grandService.imageLink = "${EndPoints.DOCUMENT}${service['image']}";
          model.add(grandService);
        }
      });
      return latestViewModel..allAvailableServices = model;
    } catch (e) {
      print(e);
      return latestViewModel;
    }
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
    } else if (event == AllServicesEvent.saveSelectedServices) {
      return latestViewModel..saving = trackFlag;
    }
    return latestViewModel;
  }

  Future<AllService> fetchParentService(Map<String, dynamic> message) async {
    String grandID = message['ID'];
    if (serviceCache.containsKey(grandID))
      return latestViewModel..parentServices = serviceCache[grandID];
    String query = '''
    {
	service(id:"$grandID") {
    children{
      id
      name
      excerpt
      image
      priceable
    }
  }
}
    ''';
    try {
      Map response = await CustomGraphQLClient.instance.query(query);
      List<ServiceOptionModel> parentServices = [];
      List parent = response['service']['children'];
      parent.forEach((parent) {
        if (parent != null) {
          ServiceOptionModel parentService = ServiceOptionModel();
          parentService.id = parent['id'];
          parentService.serviceName = parent['name'];
          parentService.rawExcerpt = parent['excerpt'];
          parentService.excerpt = Excerpt(parent['excerpt']);
          if (parent['image'] != null)
            parentService.imageLink = "${EndPoints.DOCUMENT}${parent['image']}";
          parentService.priceable = parent['priceable'];
          if (mySelectedServiceList == null)
            parentServices.add(parentService);
          else if (mySelectedServiceList != null &&
              !mySelectedServiceList.contains(parentService.id))
            parentServices.add(parentService);
        }
      });
      serviceCache[grandID] = parentServices;
      return latestViewModel..parentServices = parentServices;
    } catch (e) {
      print(e);
      return latestViewModel;
    }
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
	service(id:"$parentId") {
    children{
      id
      name
      excerpt
      image
    }
  }
}
''';
    try {
      Map response = await CustomGraphQLClient.instance.query(query);
      List children = response['service']['children'];
      List<ServiceOptionModel> childServices = [];
      children.forEach((child) {
        if (child != null) {
          ServiceOptionModel c = ServiceOptionModel();
          c.id = child['id'];
          c.serviceName = child['name'];
          c.rawExcerpt = child['excerpt'];
          c.excerpt = Excerpt(child['excerpt']);
          if (child['image'] != null)
            c.imageLink = "${EndPoints.DOCUMENT}${child['image']}";
          if (mySelectedServiceList == null)
            childServices.add(c);
          else if (mySelectedServiceList != null &&
              !mySelectedServiceList.contains(c.id))
            childServices.add(c);
        }
      });
      serviceCache[parentId] = childServices;
      return latestViewModel..childServices = childServices;
    } catch (e) {
      print(e);
      return latestViewModel;
    }
  }

  Future<AllService> saveSelectedServices() async {
    String query = '''
    mutation {
  update(input: {
    addServices: ${latestViewModel.selectedServices.map((service) {
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

    await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }
}
