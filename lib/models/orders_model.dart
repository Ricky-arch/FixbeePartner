import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'package:fixbee_partner/ui/custom_widget/addon.dart';
import 'package:fixbee_partner/ui/custom_widget/services.dart';

class Orders extends ViewModel {
  String serviceName;
  int quantity;
  List<Service> addOns = [];
  bool cashOnDelivery;
  String id;
  User user = User();
  String otp;
  String status;
  String address;
  String timeStamp;
  String placeId;
  int amount;
}
