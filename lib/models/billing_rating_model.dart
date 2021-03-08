import 'package:fixbee_partner/models/history_model.dart';
import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/view_model.dart';

class BillingRatingModel extends ViewModel{
  int score;
  String review;
  bool whileFetchingBillDetails=false;
  Receipt receipt=Receipt();
  OrderModel orderModel= OrderModel();
}
class Receipt{
  String referenceId;
  int amount;
  Payment payment=Payment();
  String userName;
  List<ServiceOptionModel> services= [];
}
