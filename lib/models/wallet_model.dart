import 'package:fixbee_partner/models/view_model.dart';

import 'bank_details_model.dart';

class WalletModel extends ViewModel{
  int amount;
  int walletAmount;
  bool bankAccountFetching=false;
  bool whileFetchingWalletAmount=false;
  bool whileWithDrawingAmount=false;
  int depositAmount;
  int withdrawAmount;
  int numberOfAccounts;
  String paymentID;
  String signature;
  bool isProcessed=false;
  List<BankModel> bankAccountList=[];
  String referenceId;
  List<VpaModel> vpaList=[];
}