import 'package:fixbee_partner/events/event.dart';

class RatingEvent extends Event{
  RatingEvent(int eventId) : super(eventId);
  static final RatingEvent addRatingEvent= RatingEvent(100);
}