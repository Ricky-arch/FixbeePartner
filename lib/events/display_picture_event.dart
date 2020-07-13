import 'package:fixbee_partner/events/event.dart';

class DisplayPictureEvent extends Event{
  DisplayPictureEvent(int eventId) : super(eventId);
  static final DisplayPictureEvent uploadDisplayPicture= DisplayPictureEvent(100);
  static final DisplayPictureEvent downloadDisplayPicture=DisplayPictureEvent(101);
}