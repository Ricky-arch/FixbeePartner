import 'package:fixbee_partner/models/order_model.dart';
import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'bee_model.dart';

class WorkScreenModel extends ViewModel {
  OrderModel jobModel = OrderModel();
  bool onServiceStarted = false;
  bool otpValid = false;
  double userRating = 0;
  Orders ordersModel = Orders();
  bool slotted = false;
  bool orderResolved = false;
  bool onJobCompleted = false;
  String activeOrderStatus = "";
  int ratingScore;
  String ratingRemark;
  bool ratedSuccessfully = false;
  String otpInvalidMessage = "";
  bool paymentReceived=false;
  String receivePaymentError;
  bool receivingPayment=false;
  int payment;
  bool fetchingPaymentAmount=false;
}
