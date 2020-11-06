import 'package:fixbee_partner/models/view_model.dart';

import 'bank_details_model.dart';

class WalletModel extends ViewModel{
  int amount;
  bool bankAccountFetching=false;
  int depositAmount;
  int withdrawAmount;
  int numberOfAccounts;
  String paymentID;
  String signature;
  bool isProcessed=false;
  List<BankModel> bankAccountList=[];
}