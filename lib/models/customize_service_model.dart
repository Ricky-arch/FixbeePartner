import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/view_model.dart';

class CustomizeServiceModel extends ViewModel{
 List<ServiceOptionModel> selectedServiceOptionModel= [];
 int numberOfSelectedServices=0;
 bool fetchSelectedServices=false;
 List<ServiceOptionModel> unselectedServiceOptionModel=[];
 int numberOfUnselectedServices=0;
}

