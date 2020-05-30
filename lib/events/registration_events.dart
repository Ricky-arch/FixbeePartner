
import 'package:fixbee_partner/events/event.dart';

class RegistrationEvents extends Event {
  static final RegistrationEvents registrationFieldSet= new RegistrationEvents(200);
  static final RegistrationEvents onLogin = new RegistrationEvents(201);
  static final RegistrationEvents requestOtp= new RegistrationEvents(202);
  RegistrationEvents(int eventId) : super(eventId);

}