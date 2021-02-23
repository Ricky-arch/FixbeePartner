import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/login_events.dart';
import 'package:fixbee_partner/models/login_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:fixbee_partner/utils/request_maker.dart';
import 'flavours.dart';

class LoginBloc extends Bloc<LoginEvents, LoginModel>
    with Trackable<LoginEvents, LoginModel> {
  LoginBloc(LoginModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<LoginModel> mapEventToViewModel(
      LoginEvents event, Map<String, dynamic> message) async {
    if (event == LoginEvents.onLogIn) {
      return await ConflictResolver(
          primarySource: () => _request(message),
          fallback: (err) async => latestViewModel..exist = false).supply();
    }
    return latestViewModel;
  }

  @override
  LoginModel setTrackingFlag(LoginEvents event, bool loading, Map message) {
    return latestViewModel..loading = loading;
  }

  Future<LoginModel> _request(Map<String, dynamic> message) async {
    String query='''mutation {
  sendOtp(input:{phone:"${message['phone']}"}) {
    phone
  }
}''';
    try{
      Map response= await CustomGraphQLClient.instance.mutate(query);
      return latestViewModel..exist=true;
    }
    catch(e){
      print(e);
      return latestViewModel..exist=false;
    }
   // if( response.containsKey('sent') && response['sent'])    {
   //   print(response['otp']);
   //    return latestViewModel..exist = true;
   //  } else {
   //    return latestViewModel..exist = false;
   //  }
  }
}
