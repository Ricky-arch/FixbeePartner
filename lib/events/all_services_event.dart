import 'package:fixbee_partner/events/event.dart';

class AllServicesEvent extends Event{
  AllServicesEvent(int eventId) : super(eventId);

  static final AllServicesEvent fetchTreeService= AllServicesEvent(100);
  static final AllServicesEvent fetchParentService=AllServicesEvent(101);
  static final AllServicesEvent fetchChildServices= AllServicesEvent(102);
  static final AllServicesEvent setCheckBox= AllServicesEvent(103);
  static final AllServicesEvent saveSelectedServices= AllServicesEvent(104);
}