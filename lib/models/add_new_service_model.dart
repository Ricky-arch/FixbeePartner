import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/view_model.dart';

class AddNewServiceModel extends  ViewModel {
  List<ServiceOptionModel> allServicesAvailableForMe=[];
  List<ServiceOptionModel> newSelectedServices=[];
  int numberOfUnselectedServices=0;
}