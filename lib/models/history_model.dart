import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/view_model.dart';

import 'order_model.dart';

class HistoryModel extends ViewModel {
 List<OrderModel> pastOrderList= [];
 List<CreditTransactions> creditTransactions= [];
 List<DebitTransactions> debitTransaction=[];
 User user = User();
 Service service=Service();
 Order order=Order();
 Location location=Location();
 OrderModel jobModel= OrderModel();
 bool pastOrderPresent=false;
 bool isOrderActive=false;
}
class CreditTransactions{
 int amount;
 DateTime timeStamp;
}
class DebitTransactions{
 int amount;
 DateTime timeStamp;
}