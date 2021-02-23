import 'package:fixbee_partner/events/event.dart';

class LoginEvents extends Event{
  LoginEvents(int eventId) : super(eventId);
  static final LoginEvents onLogIn= LoginEvents(100);
}