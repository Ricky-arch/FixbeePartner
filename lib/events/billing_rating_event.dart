import 'package:fixbee_partner/events/event.dart';

class BillingRatingEvent extends Event{
  BillingRatingEvent(int eventId) : super(eventId);
  static final BillingRatingEvent addRatingEvent= BillingRatingEvent(100);
  static final BillingRatingEvent fetchOderBillDetails= BillingRatingEvent(101);

}