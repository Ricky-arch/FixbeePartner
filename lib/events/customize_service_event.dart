
import 'package:fixbee_partner/events/event.dart';

class CustomizeServiceEvent extends Event{
  CustomizeServiceEvent(int eventId) : super(eventId);
  static final CustomizeServiceEvent fetchSelectedServices= CustomizeServiceEvent(100);
  static final CustomizeServiceEvent deleteSelectedService= CustomizeServiceEvent(101);
  static final CustomizeServiceEvent fetchAvailableServices= CustomizeServiceEvent(102);
  static final CustomizeServiceEvent checkAvailability= CustomizeServiceEvent(103);
}