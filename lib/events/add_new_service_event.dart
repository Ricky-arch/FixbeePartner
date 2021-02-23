import 'package:fixbee_partner/events/event.dart';

class AddNewServiceEvent extends Event{
  AddNewServiceEvent(int eventId) : super(eventId);
  static final AddNewServiceEvent fetchServicesAvailableForMe= AddNewServiceEvent(100);
  static final AddNewServiceEvent saveSelectedServices=AddNewServiceEvent(101);
}