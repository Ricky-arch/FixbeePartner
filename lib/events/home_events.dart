import 'package:fixbee_partner/events/event.dart';

class HomeEvents extends Event {
  static final HomeEvents activityStatusSet= HomeEvents(100);
  static final HomeEvents activityStatusReset= HomeEvents(101);
  static final HomeEvents activityStatusRequested= HomeEvents(102);
  static final HomeEvents activityStatusFetched= HomeEvents(103);
  static final HomeEvents updateLiveLocation = HomeEvents(104);
  static final HomeEvents getLiveLocation=HomeEvents(105);

  HomeEvents(int eventId) : super(eventId);
}
