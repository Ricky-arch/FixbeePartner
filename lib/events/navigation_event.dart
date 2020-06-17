import 'package:fixbee_partner/events/event.dart';

class NavigationEvent extends Event{
  NavigationEvent(int eventId) : super(eventId);
  static final NavigationEvent gotJobNotification= NavigationEvent(100);

}