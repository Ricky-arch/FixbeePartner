import 'package:fixbee_partner/models/view_model.dart';

class ServiceOptionModel extends ViewModel {
  String id;
  bool selected = false;
  String serviceName;
  bool availability;
  String imageLink;
  String parentName;
  List<ServiceOptionModel> subServices = [];
}

class ServiceOptionModels extends ViewModel {
  List<ServiceOptionModel> serviceOptions = [];
  List<ServiceOptionModel> selectedServices = [];
  bool fetching = true;
  bool saving = false;
}
