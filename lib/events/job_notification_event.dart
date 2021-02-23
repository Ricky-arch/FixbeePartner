import 'package:fixbee_partner/events/event.dart';

class JobNotificationEvents extends Event {
  static final JobNotificationEvents onJobReceived = JobNotificationEvents(100);
  static final JobNotificationEvents onJobAccepted = JobNotificationEvents(101);
  static final JobNotificationEvents onJobDeclined = JobNotificationEvents(102);
  JobNotificationEvents(int eventId) : super(eventId);
}
