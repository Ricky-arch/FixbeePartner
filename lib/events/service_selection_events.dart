
import 'package:fixbee_partner/events/event.dart';

class ServiceSelectionEvents extends Event {
  static final ServiceSelectionEvents fetchAvailableServices= ServiceSelectionEvents(300);
  static final ServiceSelectionEvents saveSelectedServices= ServiceSelectionEvents(301);
  static final ServiceSelectionEvents checkServices= ServiceSelectionEvents(302);
  ServiceSelectionEvents(int eventId) : super(eventId);

}