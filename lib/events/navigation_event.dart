import 'package:fixbee_partner/events/event.dart';

class NavigationEvent extends Event{
  NavigationEvent(int eventId) : super(eventId);
  static final NavigationEvent onMessage=NavigationEvent(100);
  static final NavigationEvent getServiceData= NavigationEvent(102);
  static final NavigationEvent getUserData= NavigationEvent(103);
  static final NavigationEvent onConfirmJob=NavigationEvent(101);
  static final NavigationEvent getActiveOrder=NavigationEvent(104);
  static final NavigationEvent checkActiveService=NavigationEvent(105);
  static final NavigationEvent updateLiveLocation= NavigationEvent(107);
  static final NavigationEvent checkActiveOrderStatus= NavigationEvent(106);
  static final NavigationEvent startTimer= NavigationEvent(107);
  static final NavigationEvent endTimer= NavigationEvent(108);
  static final NavigationEvent updateFcmTest=NavigationEvent(109);
}