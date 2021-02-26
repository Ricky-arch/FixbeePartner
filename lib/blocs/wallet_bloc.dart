import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/wallet_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'package:fixbee_partner/models/wallet_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'dart:developer';

class WalletBloc extends Bloc<WalletEvent, WalletModel>
    with Trackable<WalletEvent, WalletModel> {
  WalletBloc(WalletModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<WalletModel> mapEventToViewModel(
      WalletEvent event, Map<String, dynamic> message) async {
    if (event == WalletEvent.fetchWalletAmount) {
      return await fetchWalletAmount();
    }
    if (event == WalletEvent.fetchBankAccountsForWithdrawal) {
      return await fetchBankAccountsForWithdrawal();
    }
    if (event == WalletEvent.withdrawAmount) {
      return await withdrawAmount(message);
    }
    if (event == WalletEvent.createWalletDeposit) {
      return await createWalletDeposit(message);
    }
    if (event == WalletEvent.processWalletDeposit) {
      return await processWalletDeposit(message);
    }
    if (event == WalletEvent.fetchWalletAmountAfterTransaction) {
      return await fetchWalletAmountAfterTransaction();
    }
    return latestViewModel;
  }

  Future<WalletModel> fetchWalletAmountAfterTransaction() async {
    String query = '''{
  wallet{
    amount
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    DataStore.me.walletAmount = response['wallet']['amount'];
    return latestViewModel..amount = response['wallet']['amount'];
  }

  Future<WalletModel> fetchWalletAmount() async {
    String query = '''{
  wallet{
    amount
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);

    DataStore.me.walletAmount = response['wallet']['amount'];
    latestViewModel.walletAmount=response['wallet']['amount'];
    print(latestViewModel.walletAmount.toString()+'FROM BLOC');
    return latestViewModel..amount = response['wallet']['amount'];
  }

  Future<WalletModel> fetchBankAccountsForWithdrawal() async {
    List<BankModel> bankAccounts = [];
    List<VpaModel> vpaAccounts = [];
    String query = '''{
  accounts{
    id
   bank_account{
    name
    account_number
  }
    vpa{
      address
      
    }
    account_type
  }
}''';
    try {
      Map response = await CustomGraphQLClient.instance.query(query);
      List accounts = response['accounts'];
      latestViewModel..numberOfAccounts = accounts.length;
      accounts.forEach((account) {
        if (account['account_type'] == 'bank_account') {
          BankModel bm = BankModel();
          bm.accountHoldersName = account['bank_account']['name'];
          bm.accountID = account['id'];
          bm.bankAccountNumber = account['bank_account']['account_number'];
          bankAccounts.add(bm);
        } else {
          VpaModel vm = VpaModel();
          vm.address = account['vpa']['address'];
          vm.id = account['id'];
          vpaAccounts.add(vm);
        }
      });
      return latestViewModel
        ..bankAccountList = bankAccounts
        ..vpaList = vpaAccounts;
    } catch (e) {
      return latestViewModel;
    }
  }

  @override
  WalletModel setTrackingFlag(WalletEvent event, bool trackFlag, Map message) {
    if (event == WalletEvent.fetchBankAccountsForWithdrawal)
      latestViewModel..bankAccountFetching = trackFlag;
    if (event == WalletEvent.fetchWalletAmount)
      latestViewModel..whileFetchingWalletAmount = trackFlag;
    if (event == WalletEvent.withdrawAmount)
      return latestViewModel..whileWithDrawingAmount = trackFlag;
    return latestViewModel;
  }

  Future<WalletModel> withdrawAmount(Map<String, dynamic> message) async {
    String id = message['accountId'];
    int amount = message['amount'];
    String query = '''mutation{
  transferFunds(input:{amount:$amount,faId:"$id"}) {
    column
    amount
    currency
    referenceId
    faId
    payment {
      amount
      currency
      status
      method
      refund_status
      amount_refunded
      captured
    }
    payout {
      amount
      currency
      status
      mode
      utr
    }
    paymentId
    payoutId
  } 
}
''';
    try{
      Map response=await CustomGraphQLClient.instance.mutate(query);
      return latestViewModel;
    }
    catch(e){
      return latestViewModel;
    }

  }

  Future<WalletModel> createWalletDeposit(Map<String, dynamic> message) async {
    int amount = message['Amount'];
    String query = '''mutation{
  addFunds(input:{amount:$amount}) {
    amount
    currency
    referenceId
    paymentId
    payoutId
  }
}''';
    try {
      Map response = await CustomGraphQLClient.instance.mutate(query);
      return latestViewModel
        ..paymentID = response['addFunds']['paymentId']
        ..referenceId = response['addFunds']['referenceId'];
    } catch (e) {
      return latestViewModel;
    }
  }

  Future<WalletModel> processWalletDeposit(Map<String, dynamic> message) async {
    String paymentID = message['paymentID'];
    String paymentSignature = message['paymentSignature'];
    String orderID = message['orderID'];
    String query = '''
    mutation {
  isProcessed:ProcessWalletDeposit(
    PaymentId: "$paymentID"
    PaymentSignature: "$paymentSignature"
  )
}
    ''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    log(response['isProcessed'].toString(), name: "isProcessed");
    return latestViewModel..isProcessed = response['isProcessed'];
  }
}
