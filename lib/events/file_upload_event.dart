import 'package:fixbee_partner/events/event.dart';

class FileUploadEvent extends Event{
  FileUploadEvent(int eventId) : super(eventId);
  static final FileUploadEvent uploadFile= FileUploadEvent(100);
}