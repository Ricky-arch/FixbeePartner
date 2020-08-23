import 'package:fixbee_partner/models/view_model.dart';

import 'order_model.dart';

class HistoryModel extends ViewModel {
 List<OrderModel> pastOrderList= [];
 List<CreditTransactions> creditTransactions= [];
 List<DebitTransactions> debitTransaction=[];
}
class CreditTransactions{
 int amount;
 DateTime timeStamp;
}
class DebitTransactions{
 int amount;
 DateTime timeStamp;
}