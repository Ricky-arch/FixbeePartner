import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/wallet_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
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
    return latestViewModel;
  }

  Future<WalletModel> fetchWalletAmount() async {
    String query = '''{
    Me{
      ...on Bee{
                Wallet{
                       Amount
                       }
                }
       }
   }''';
    Map response = await CustomGraphQLClient.instance.query(query);
    DataStore.me.walletAmount = response['Me']['Wallet']['Amount'];
    return latestViewModel..amount = response['Me']['Wallet']['Amount'];
  }

  Future<WalletModel> fetchBankAccountsForWithdrawal() async {
    List<BankModel> models = [];
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
    print("HelloWorld");

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

  @override
  WalletModel setTrackingFlag(WalletEvent event, bool trackFlag, Map message) {
    if (event == WalletEvent.fetchBankAccountsForWithdrawal)
      return latestViewModel..bankAccountFetching = trackFlag;
    return latestViewModel;
  }

  Future<WalletModel> withdrawAmount(Map<String, dynamic> message) async {
    String id = message['accountId'];
    int amount = message['amount'];
    String query = '''mutation{
  ProcessWalletWithdraw(Amount:$amount, AccountId:$id){
    ...on Debit{
      Amount
      Notes
      TimeStamp
    }
  }
}''';
    await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  Future<WalletModel> createWalletDeposit(Map<String, dynamic> message) async {
    int amount = message['Amount'];
    String query = '''mutation{
  order_id:CreateWalletDeposit(Amount:$amount)
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel..paymentID = response['order_id'];
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
