import 'package:fixbee_partner/models/view_model.dart';

class BankDetailsModel extends ViewModel{
  int numberOfAccounts;
  List<BankModel> bankAccountList=[];
  bool updated=false;
  bool deleted=false;
  bool addingAccount=false;
  bool fetchingBankAccounts=false;
  bool vpaAdded=false;
  List<VpaModel> vpaList=[];
  bool addingVpaAccount=false;

}
class BankModel extends ViewModel{
  String accountHoldersName;
  String ifscCode;
  String bankAccountNumber;
  String accountID;
  bool accountVerified;
}
class VpaModel extends ViewModel{
  String id;
  String address;
}
