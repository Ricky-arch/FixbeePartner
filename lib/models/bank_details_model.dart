import 'package:fixbee_partner/models/view_model.dart';

class BankDetailsModel extends ViewModel{
  int numberOfAccounts;
  List<BankModel> bankAccountList=[];
  bool updated=false;
  bool deleted=false;
}
class BankModel extends ViewModel{
  String accountHoldersName;
  String ifscCode;
  String bankAccountNumber;
  String accountID;
  bool accountVerified;
}
