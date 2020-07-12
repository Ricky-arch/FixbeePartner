import 'package:fixbee_partner/models/view_model.dart';

class BankDetailsModel extends ViewModel{
  int numberOfAccounts;
  List<BankModel> bankAccountList=[];
}
class BankModel extends ViewModel{
  String accountHoldersName;
  String ifscCode;
  String bankAccountNumber;
  String accountID;
  bool accountVerified;
}
