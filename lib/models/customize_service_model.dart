import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/view_model.dart';

class CustomizeServiceModel extends ViewModel{
 List<ServiceOptionModel> selectedServiceOptionModel= [];
 int numberOfSelectedServices=0;
 bool fetchingMyServices=false;
 bool deletingSelectedService=false;
 List<ServiceOptionModel> unselectedServiceOptionModel=[];
 int numberOfUnselectedServices=0;
 bool availableForRemoval=true;
 bool checkingAvailabilityForRemoval=false;
 bool isDeletedSuccessfully=false;
 String errorMessage;
}

