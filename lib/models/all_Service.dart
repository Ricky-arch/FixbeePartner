import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/view_model.dart';

class AllService extends ViewModel {
  List<ServiceOptionModel> allAvailableServices=[];
  List<ServiceOptionModel> selectedServices=[];
  List<ServiceOptionModel> parentServices=[];
  List<ServiceOptionModel> childServices=[];

  bool fetching=false;
  bool fetchingParent=false;
  bool fetchingChild=false;
  bool saving=false;
  bool selected=false;
  String selectedServiceID;
  String selectedParentId;
}