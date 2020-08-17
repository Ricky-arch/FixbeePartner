import 'package:fixbee_partner/events/event.dart';

class OtpEvents extends Event{
  static final OtpEvents onOtpVerify = OtpEvents(100);
  static final OtpEvents onOtpVerified = OtpEvents(101);
  static final OtpEvents checkForServiceSelected=OtpEvents(102);
  static final OtpEvents fetchSaveBeeDetails=OtpEvents(103);
  static final OtpEvents getFcmToken=OtpEvents(104);
  static final OtpEvents resendOtp=OtpEvents(105);
  OtpEvents(int eventId) : super(eventId);

}