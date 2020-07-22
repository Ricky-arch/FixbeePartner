import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/otp_events.dart';
import 'package:fixbee_partner/graphql/client.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/otp_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:fixbee_partner/utils/request_maker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flavours.dart';

class OtpLoginBloc extends Bloc<OtpEvents, OtpModel>
    with Trackable<OtpEvents, OtpModel> {
  OtpLoginBloc(OtpModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<OtpModel> mapEventToViewModel(
      OtpEvents event, Map<String, dynamic> message) async {
    if (event == OtpEvents.onOtpVerify) {
      return await _onOtpVerify(message['phone'], message['otp']);
    }
    if (event == OtpEvents.checkForServiceSelected) {
      return await checkForServiceSelected();
    }
    if (event == OtpEvents.fetchSaveBeeDetails) {
      return await fetchSaveBeeDetails();
    }
    return latestViewModel;
  }

  @override
  OtpModel setTrackingFlag(OtpEvents event, bool loading, Map message) {
    return latestViewModel..verifying = loading;
  }

  Future<OtpModel> _onOtpVerify(String phone, String otp) async {
    Map response = await RequestMaker(
        endpoint: EndPoints.LOGIN,
        body: {'phone': phone, 'otp': otp}).makeRequest();

    if (response.containsKey('error')) {
      if (response['error'] == 'No such account exists') {
        return latestViewModel..exist = false;
      } else if (response['error'] == 'OTP invalid or past expiration') {
        return latestViewModel..exist = true;
      }
    }

    if (response.containsKey('token')) {
      await _saveToken(response['token']);
      DataStore.token = response['token'];
      latestViewModel
        ..valid = true
        ..exist = true;
    }
    return latestViewModel;
  }

  _saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.TOKEN, token);
  }

  Future<OtpModel> checkForServiceSelected() async {
    String query = '''{
  Me{
    ...on Bee{
      Services{
        Name
        ID
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List services = response['Me']['Services'];
    if (services.length != 0) return latestViewModel..serviceSelected = true;
    return latestViewModel;
  }

  Future<OtpModel> fetchSaveBeeDetails() async {
    String query = '''{
  Me{
    ...on Bee{
      ID
      Name{
        Firstname
        Middlename
        Lastname
      }
      Ratings{
        Score
      }
      Email
      Phone{Number}
      Email
      DOB
      Services{
        ID
        Name
      }
      BankAccounts{
        ID
        AccountNumber
        IFSC
        AccountHolderName
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    Bee bee = Bee()
      ..firstName = response['Me']['Name']['Firstname'] ?? ''
      ..middleName = response['Me']['Name']['Middlename'] ?? ''
      ..lastName = response['Me']['Name']['Lastname'] ?? ''
      ..phoneNumber = response['Me']['Phone']['Number'];
    DataStore.me = bee;
    return latestViewModel;
  }
}
