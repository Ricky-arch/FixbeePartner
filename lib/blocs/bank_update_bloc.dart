import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/bank_update_event.dart';
import 'package:fixbee_partner/models/bank_update_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class BankUpdateBloc extends Bloc<BankUpdateEvent, BankUpdateModel>{
  BankUpdateBloc(BankUpdateModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<BankUpdateModel> mapEventToViewModel(BankUpdateEvent event, Map<String, dynamic> message) async{

    if(event==BankUpdateEvent.fetchBankDetails){
      return await fetchBankDetails();
    }
    else if(event ==BankUpdateEvent.updateBakDetails){
      return await updateBankDetails(message);
    }
    // TODO: implement mapEventToViewModel
    return null;
  }

  Future<BankUpdateModel> fetchBankDetails() async{
    String query='''''';
    Map response= await CustomGraphQLClient.instance.query(query);

    return latestViewModel..accountHoldersName=response[''];
  }

  Future<BankUpdateModel> updateBankDetails(Map<String, dynamic> message) async{
    String query='''''';
    Map response =await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

}