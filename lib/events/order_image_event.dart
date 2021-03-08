import 'package:fixbee_partner/events/event.dart';

class OrderImageEvent extends Event {
  OrderImageEvent(int eventId) : super(eventId);
  static OrderImageEvent getImageIds = OrderImageEvent(100);
}
