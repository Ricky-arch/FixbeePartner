import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/models/view_model.dart';

class BillingRatingModel extends ViewModel{
  int score;
  String review;
  bool whileFetchingBillDetails=false;
  OrderModel orderModel= OrderModel();
}