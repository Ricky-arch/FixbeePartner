import 'dart:developer';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/bank_details_event.dart';
import 'package:fixbee_partner/events/billing_rating_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class BankDetailsBloc extends Bloc<BankDetailsEvent, BankDetailsModel>
    with Trackable<BankDetailsEvent, BankDetailsModel> {
  BankDetailsBloc(BankDetailsModel genesisViewModel) : super(genesisViewModel);
  List<BankModel> bankAccounts = [];
  List<VpaModel> vPas = [];
  @override
  Future<BankDetailsModel> mapEventToViewModel(
      BankDetailsEvent event, Map<String, dynamic> message) async {
    if (event == BankDetailsEvent.fetchAvailableAccounts)
      return await fetchAllAccounts();
    if (event == BankDetailsEvent.deleteBankAccount)
      return await deleteAccount(message);
    if (event == BankDetailsEvent.addBankAccount)
      return await addBankAccount(message);
    else if (event == BankDetailsEvent.addVpaAddress)
      return await addVpaAddress(message);
    return null;
  }

  Future<BankDetailsModel> addVpaAddress(Map<String, dynamic> message) async {
    String vpa = message['vpa'];
    String query = '''
      mutation {
        addFundsAccount(input:{
    	    address: "$vpa"
        }) {
              id
              account_type
              vpa {
                address
              }
           } 
      }
    ''';
    try {
      Map response = await CustomGraphQLClient.instance.mutate(query);
      VpaModel vm = VpaModel();
      vm.address = vpa;
      vm.id = response['addFundsAccount']['id'];
      return latestViewModel
        ..vpaAdded = true
        ..vpaList.add(vm);
    } catch (e) {
      print(e);
      return latestViewModel..vpaAdded = false;
    }
  }

  Future<BankDetailsModel> fetchAllAccounts() async {
    String query = '''{
  accounts{
    id
    account_type
    bank_account{
      name
      account_number
      ifsc
    }
    vpa{
      address
    }
  }
}''';

    Map response = await CustomGraphQLClient.instance.query(query);
    List accounts = response['accounts'];
    latestViewModel..numberOfAccounts = accounts.length;
    accounts.forEach((account) {
      if (account['account_type'] == 'bank_account') {
        BankModel bm = BankModel();
        bm.accountHoldersName = account['bank_account']['name'];
        bm.ifscCode = account['bank_account']['ifsc'];
        bm.accountID = account['id'];
        bm.bankAccountNumber = account['bank_account']['account_number'];
        bankAccounts.add(bm);
      } else {
        VpaModel vm = VpaModel();
        vm.address = account['vpa']['address'];
        vm.id = account['id'];
        vPas.add(vm);
      }
    });
    return latestViewModel
      ..bankAccountList = bankAccounts
      ..vpaList = vPas;
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

  Future<BankDetailsModel> addBankAccount(
      Map<String, dynamic> message) async {
    String accountHoldersName = message['accountHoldersName'],
        accountNumber = message['accountNumber'],
        ifsc = message['ifscCode'];
    String query = '''
      mutation {
        addFundsAccount(input:{
          name: "$accountHoldersName"
          ifsc: "$ifsc"
          account_number: "$accountNumber"
      }) {
      id
      account_type
      bank_account {
        name
        ifsc
        account_number
      }
    } 
  }
    ''';
    try {
      Map response = await CustomGraphQLClient.instance.mutate(query);
      // BankModel bm = BankModel();
      // bm.accountHoldersName = accountHoldersName;
      // bm.ifscCode = ifsc;
      // bm.accountID = response['addFundsAccount']['id'];
      // bm.bankAccountNumber = accountNumber;
      return latestViewModel
        // ..bankAccountList.add(bm)
        ..updated = true;
    } catch (e) {
      log(e.toString(), name: "Account Error");
      return latestViewModel..updated = false
          // ..bankAccountList = models
          ;
    }
  }

  @override
  BankDetailsModel setTrackingFlag(
      BankDetailsEvent event, bool trackFlag, Map message) {


    if(event== BankDetailsEvent.addBankAccount){
      latestViewModel..addingAccount = trackFlag;
    }
    else if(event== BankDetailsEvent.addVpaAddress){
      latestViewModel..addingVpaAccount=trackFlag;
    }
   
    
    return latestViewModel;
  }
}
