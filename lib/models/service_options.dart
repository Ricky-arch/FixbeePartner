import 'package:fixbee_partner/models/view_model.dart';
import 'package:fixbee_partner/utils/excerpt.dart';

class ServiceOptionModel extends ViewModel {
  String id;
  bool selected = false;
  String serviceName;
  bool availability;
  String imageLink;
  String parentName;
  bool priceable = false;
  String description;
  String rawExcerpt;
  Excerpt excerpt;
  int amount;
  List<ServiceOptionModel> subServices = [];

  // Excerpt get excerpt {
  //   if (rawExcerpt != null) _excerpt = Excerpt(rawExcerpt);
  //   return _excerpt;
  // }

}

class ServiceOptionModels extends ViewModel {
  String imageLink;
  List<ServiceOptionModel> serviceOptions = [];
  List<ServiceOptionModel> selectedServices = [];
  bool fetching = true;
  bool saving = false;
}
