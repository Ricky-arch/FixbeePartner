import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/view_model.dart';

import 'order_model.dart';

class HistoryModel extends ViewModel {
 List<OrderModel> pastOrderList= [];
 List<CreditTransactions> credits=[];
 List<CreditTransactions> creditTransactions= [];
 List<DebitTransactions> debitTransaction=[];
 User user = User();
 Service service=Service();
 Order order=Order();
 Location location=Location();
 OrderModel jobModel= OrderModel();
 bool pastOrderPresent=false;
 bool isOrderActive=false;
 bool loadingDetails=false;
 bool isCreditPresent=false;

 String checkActiveOrderStatus;
 String selectedOrderID;
}
class CreditTransactions{
 int amount;
 String timeStamp;
 String notes;
}
class DebitTransactions{
 int amount;
 DateTime timeStamp;
 String notes;
}