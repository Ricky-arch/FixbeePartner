import 'package:fixbee_partner/models/view_model.dart';

class ServiceOptionModel extends ViewModel {
  String id;
  bool selected = false;
  String serviceName;
  bool availability;
  String imageLink;
  String parentName;
  bool priceable=false;
  String description;
  String excerpt;
  List<ServiceOptionModel> subServices = [];
}

class ServiceOptionModels extends ViewModel {
  String imageLink;
  List<ServiceOptionModel> serviceOptions = [];
  List<ServiceOptionModel> selectedServices = [];
  bool fetching = true;
  bool saving = false;
}
