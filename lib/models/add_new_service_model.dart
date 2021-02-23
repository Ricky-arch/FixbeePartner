import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/view_model.dart';

class AddNewServiceModel extends ViewModel {
  Map<String, List<ServiceOptionModel>> allServicesAvailableForMe = {};
  List<ServiceOptionModel> newSelectedServices = [];
  int numberOfUnselectedServices = 0;
  bool loading=false;
}
