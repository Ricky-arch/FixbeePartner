import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/wallet_event.dart';
import 'package:fixbee_partner/models/wallet_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class WalletBloc extends Bloc<WalletEvent, WalletModel> {
  WalletBloc(WalletModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<WalletModel> mapEventToViewModel(
      WalletEvent event, Map<String, dynamic> message) async {
    if (event == WalletEvent.fetchWalletAmount) {
      return await fetchWalletAmount();
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
    return latestViewModel..amount=response['Me']['Wallet']['Amount'];
  }
}
