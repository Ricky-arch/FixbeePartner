import 'package:fixbee_partner/models/view_model.dart';

import 'bee_model.dart';

class OtpModel extends ViewModel{
  bool valid=false;
  bool verifying=false;
  bool enableButton=false;

  bool serviceSelected=false;
  bool resendingOtp=false;
  bool fetchingAllBeeConfiguration=false;
  bool gotBeeDetails=false;
  bool walletError=false;
  String errorMessage;
  Bee bee;


}