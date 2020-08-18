import 'dart:developer';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/bank_details_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class BankDetailsBloc extends Bloc<BankDetailsEvent, BankDetailsModel> {
  BankDetailsBloc(BankDetailsModel genesisViewModel) : super(genesisViewModel);
  List<BankModel> models = [];
  @override
  Future<BankDetailsModel> mapEventToViewModel(
      BankDetailsEvent event, Map<String, dynamic> message) async {
    if (event == BankDetailsEvent.fetchAvailableAccounts)
      return await fetchAllAccounts();
    if (event == BankDetailsEvent.deleteBankAccount)
      return await deleteAccount(message);
    if (event == BankDetailsEvent.updateBankAccount)
      return await updateBankAccount(message);
    return null;
  }

  Future<BankDetailsModel> fetchAllAccounts() async {
    String query = '''{
  Me{
    ... on Bee{
      ID
      BankAccounts{
        ID
        AccountNumber
        IFSC
        AccountHolderName
        Verified
      }
    }
  }
}''';

    Map response = await CustomGraphQLClient.instance.query(query);
    List accounts = response['Me']['BankAccounts'];
    latestViewModel..numberOfAccounts = accounts.length;
    accounts.forEach((account) {
      BankModel bm = BankModel();
      bm.accountHoldersName = account['AccountHolderName'];
      bm.ifscCode = account['IFSC'];
      bm.accountVerified = account['Verified'];
      bm.accountID = account['ID'];
      bm.bankAccountNumber = account['AccountNumber'];
      models.add(bm);
    });
    return latestViewModel..bankAccountList = models;
  }

  Future<BankDetailsModel> deleteAccount(Map<String, dynamic> message) async {
    String id = message['accountID'];
    String query = '''mutation{
  Update(input:{RemoveBankAccount:"$id"}){
    ... on Bee{
      ID
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);

    return latestViewModel
      ..bankAccountList.removeWhere((element) => element.accountID == id);
  }

  Future<BankDetailsModel> updateBankAccount(
      Map<String, dynamic> message) async {
    String accountHoldersName = message['accountHoldersName'],
        accountNumber = message['accountNumber'],
        ifsc = message['ifscCode'];
    String query = '''mutation{
  Update(input:
    {
      AddBankAccount: {
        AccountNumber:"$accountNumber"
        IFSC:"$ifsc"
        AccountHolderName:"$accountHoldersName"
      }
    }
  ){
    ... on Bee{
      ID
      BankAccounts{
        ID
        IFSC
        AccountNumber
        AccountHolderName
        Verified
      }
    }
  }
  
}
    ''';

    Map response = await CustomGraphQLClient.instance.mutate(query);
    List accounts = response['Update']['BankAccounts'];
    latestViewModel..numberOfAccounts = accounts.length;
    accounts.forEach((account) {
      BankModel bm = BankModel();
      bm.accountHoldersName = account['AccountHolderName'];
      bm.ifscCode = account['IFSC'];
      bm.accountVerified = account['Verified'];
      bm.accountID = account['ID'];
      bm.bankAccountNumber = account['AccountNumber'];
      models.add(bm);
    });
    return latestViewModel..bankAccountList = models.. updated=true;
  }
}
