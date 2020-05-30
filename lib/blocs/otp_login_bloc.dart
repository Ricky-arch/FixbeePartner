import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/otp_events.dart';
import 'package:fixbee_partner/models/otp_model.dart';
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

    if (response.containsKey('error') &&
        response['error'] == 'No such account exists') {
      return latestViewModel..exist = false;
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
}
