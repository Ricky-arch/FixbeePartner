import 'package:fixbee_partner/events/event.dart';

class BankUpdateEvent extends Event{
  BankUpdateEvent(int eventId) : super(eventId);
  static final BankUpdateEvent fetchBankDetails= BankUpdateEvent(100);
  static final BankUpdateEvent updateBakDetails= BankUpdateEvent(101);
}