import 'package:fixbee_partner/events/event.dart';

class BankDetailsEvent extends Event{
  BankDetailsEvent(int eventId) : super(eventId);
  static final BankDetailsEvent fetchAvailableAccounts=BankDetailsEvent(100);
  static final BankDetailsEvent deleteBankAccount=BankDetailsEvent(101);
  static final BankDetailsEvent updateBankAccount=BankDetailsEvent(102);
}