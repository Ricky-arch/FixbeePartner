import 'package:fixbee_partner/events/event.dart';

class WalletEvent extends Event{
  WalletEvent(int eventId) : super(eventId);
  static WalletEvent fetchWalletAmount= WalletEvent(100);
  static WalletEvent depositAmount=WalletEvent(101);
  static WalletEvent fetchBankAccountsForWithdrawal=WalletEvent(102);
  static WalletEvent withdrawAmount=WalletEvent(103);
}