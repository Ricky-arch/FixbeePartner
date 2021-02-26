import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/view_model.dart';

import 'order_model.dart';

class HistoryModel extends ViewModel {
 List<Transactions> transactions=[];
 List<OrderModel> pastOrderList= [];
 List<CreditTransactions> credits=[];
 List <DebitTransactions> debits=[];
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
 bool isDebitPresent=false;

 String checkActiveOrderStatus;
 String selectedOrderID;
}
class CreditTransactions{
 int amount;
 String timeStamp;
 String notes;
 bool creditOnOrder=false;
}
class DebitTransactions{
 int amount;
 String timeStamp;
 String withDrawlTransactionId;
 String accountID;
 String withDrawlAccountHolderName;
 String withDrawlAccountNumber;
 String orderId;
 bool debitOnOrder=false;
}
class Transactions{
 int amount;
 String column, currency, referenceId, fald, paymentId, payoutId;
 DateTime createdAt;
 Payment payment= Payment();
 Payout payout= Payout();
}

class Payout{
 int amount;
 String currency, status, mode, utr;
}
class Payment{
 int amount;

 String currency, status, method, refundStatus, amountRefunded;
 bool captured;
}