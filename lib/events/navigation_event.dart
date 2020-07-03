import 'package:fixbee_partner/events/event.dart';

class NavigationEvent extends Event{
  NavigationEvent(int eventId) : super(eventId);
  static final NavigationEvent gotJobNotificationID= NavigationEvent(100);
  static final NavigationEvent getJobNotification=NavigationEvent(101);

}