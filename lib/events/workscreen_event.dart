import 'package:fixbee_partner/events/event.dart';

class WorkScreenEvents extends Event{
  WorkScreenEvents(int eventId) : super(eventId);
  static final WorkScreenEvents fetchOrderDetails= WorkScreenEvents(100);
  static final WorkScreenEvents fetchUserDp= WorkScreenEvents(101);
  static final WorkScreenEvents verifyOtpToStartService=WorkScreenEvents(102);
  static final WorkScreenEvents rateUser=WorkScreenEvents(103);
  static final WorkScreenEvents findUserRating= WorkScreenEvents(108);
  static final WorkScreenEvents cancelAcceptedJob= WorkScreenEvents(104);
  static final WorkScreenEvents onJobCompletion=WorkScreenEvents(105);
  static final WorkScreenEvents checkActiveOrderStatus= WorkScreenEvents(106);
  static final WorkScreenEvents refreshOrderDetails= WorkScreenEvents(107);
  static final WorkScreenEvents updateLiveLocation=WorkScreenEvents(108);
  static final WorkScreenEvents receivePayment=WorkScreenEvents(109);
  static final WorkScreenEvents receiptCall= WorkScreenEvents(110);

}