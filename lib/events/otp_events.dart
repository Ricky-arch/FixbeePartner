import 'package:fixbee_partner/events/event.dart';

class OtpEvents extends Event{
  static final OtpEvents onOtpVerify = OtpEvents(100);
  static final OtpEvents onOtpVerified = OtpEvents(101);
  OtpEvents(int eventId) : super(eventId);

}