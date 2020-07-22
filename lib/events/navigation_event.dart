import 'package:fixbee_partner/events/event.dart';

class NavigationEvent extends Event{
  NavigationEvent(int eventId) : super(eventId);

  static final NavigationEvent onMessage=NavigationEvent(100);
  static final NavigationEvent getServiceData= NavigationEvent(102);
  static final NavigationEvent getUserData= NavigationEvent(103);
  static final NavigationEvent onConfirmDeclineJob=NavigationEvent(101);

}