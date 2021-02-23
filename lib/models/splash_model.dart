import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/view_model.dart';

class SplashModel extends ViewModel{
  bool connection=true;
  bool tokenFound=false;
  bool serviceSelected=false;
  bool jobOngoing=false;
  bool tryReconnecting=false;
  Bee me;
}