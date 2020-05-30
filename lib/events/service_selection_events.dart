import 'package:fixbee_partner/data_provider/parcelable.dart';
import 'package:fixbee_partner/events/event.dart';

class ServiceSelectionEvents extends Event with Parcelable{
  static final ServiceSelectionEvents fetchAvailableServices= ServiceSelectionEvents(300);
  static final ServiceSelectionEvents saveSelectedServices= ServiceSelectionEvents(301);
  static final ServiceSelectionEvents checkServices= ServiceSelectionEvents(302);
  ServiceSelectionEvents(int eventId) : super(eventId);

}