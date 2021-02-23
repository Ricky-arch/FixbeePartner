import 'package:fixbee_partner/events/event.dart';

class HomeEvents extends Event {
  static final HomeEvents activityStatusSet= HomeEvents(100);
  static final HomeEvents activityStatusReset= HomeEvents(101);
  static final HomeEvents activityStatusRequested= HomeEvents(102);
  static final HomeEvents activityStatusFetched= HomeEvents(103);
  static final HomeEvents updateLiveLocation = HomeEvents(104);
  static final HomeEvents getDeviceLocation=HomeEvents(105);
  static final HomeEvents getDocumentVerificationStatus=HomeEvents(106);

  HomeEvents(int eventId) : super(eventId);
}
