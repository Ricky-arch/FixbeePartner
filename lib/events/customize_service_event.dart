
import 'package:fixbee_partner/events/event.dart';

class CustomizeServiceEvent extends Event{
  CustomizeServiceEvent(int eventId) : super(eventId);
  static final CustomizeServiceEvent fetchSelectedServices= CustomizeServiceEvent(100);
}