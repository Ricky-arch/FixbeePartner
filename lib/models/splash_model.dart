import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/view_model.dart';

class SplashModel extends ViewModel{
  bool connection=true;
  bool tokenFound=false;
  bool serviceSelected=false;
  bool jobOngoing=false;
  bool tryReconnecting=false;
  bool hasError=false;
  String errorMessage;

  Bee me;
  MetaData metadata=MetaData();
}

class MetaData {
  String helpline, email;
  List<String> officeTimings=[];
  int buildNumber, minimumWalletDeposit, minimumWalletAmount;
  bool criticalUpdate=false, available=true;
  int currentAppBuildNumber=0;
}