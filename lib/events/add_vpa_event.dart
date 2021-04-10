import 'package:fixbee_partner/events/event.dart';

class AddVpaEvent extends Event{
  AddVpaEvent(int eventId) : super(eventId);
  static final AddVpaEvent addVpa= AddVpaEvent(100);
}