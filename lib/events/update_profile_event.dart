import 'package:fixbee_partner/events/event.dart';

class UpdateProfileEvent extends Event{
  UpdateProfileEvent(int eventId) : super(eventId);
  static final UpdateProfileEvent fetchProfile= new UpdateProfileEvent(100);
  static final UpdateProfileEvent updateProfile= new UpdateProfileEvent(101);
}