import 'package:fixbee_partner/events/add_vpa_event.dart';
import 'package:fixbee_partner/models/add_vpa_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../bloc.dart';
import 'flavours.dart';

class AddVpaBloc extends Bloc<AddVpaEvent, AddVpaModel> with Trackable<AddVpaEvent, AddVpaModel>{
  AddVpaBloc(AddVpaModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<AddVpaModel> mapEventToViewModel(AddVpaEvent event, Map<String, dynamic> message) async{


    return latestViewModel;
  }

  Future<bool> addVpa(Map<String, dynamic> message) async{
    String vpa=message['vpa'];
    String query='''
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
    try{
      await CustomGraphQLClient.instance.mutate(query);
      return true;
    }
    catch(e){
      return false;
    }

}

  @override
  AddVpaModel setTrackingFlag(AddVpaEvent event, bool trackFlag, Map message)  {
    if(event==AddVpaEvent.addVpa)
      return latestViewModel..adding=trackFlag;
   return latestViewModel;
  }

}