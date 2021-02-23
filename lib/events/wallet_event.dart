import 'package:fixbee_partner/events/event.dart';

class WalletEvent extends Event {
  WalletEvent(int eventId) : super(eventId);
  static WalletEvent fetchWalletAmount = WalletEvent(100);
  static WalletEvent createWalletDeposit = WalletEvent(101);
  static WalletEvent processWalletDeposit = WalletEvent(104);
  static WalletEvent fetchBankAccountsForWithdrawal = WalletEvent(102);
  static WalletEvent withdrawAmount = WalletEvent(103);
  static WalletEvent fetchWalletAmountAfterTransaction=WalletEvent(105);
}
