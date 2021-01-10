import 'package:fixbee_partner/events/event.dart';

class CustomProfileEvent extends Event{
  CustomProfileEvent(int eventId) : super(eventId);
  static final CustomProfileEvent updateDp= CustomProfileEvent(100);
  static final CustomProfileEvent downloadDp= CustomProfileEvent(101);
  static final CustomProfileEvent checkForVerifiedAccount= CustomProfileEvent(102);
  static final CustomProfileEvent deactivateBee= CustomProfileEvent(103);
}