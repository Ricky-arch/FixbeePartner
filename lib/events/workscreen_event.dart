import 'package:fixbee_partner/events/event.dart';

class WorkScreenEvents extends Event{
  WorkScreenEvents(int eventId) : super(eventId);
  static final WorkScreenEvents fetchOrderDetails= WorkScreenEvents(100);
  static final WorkScreenEvents fetchUserDp= WorkScreenEvents(101);
}