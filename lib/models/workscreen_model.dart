import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'bee_model.dart';

class WorkScreenModel extends ViewModel {
  OrderModel jobModel= OrderModel();
  bool onServiceStarted=false;
  bool otpValid=false;
  int userRating;
  bool slotted=false;
  bool orderResolved=false;
  bool onJobCompleted=false;
  String activeOrderStatus;


}
