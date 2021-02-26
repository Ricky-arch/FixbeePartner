import 'package:fixbee_partner/events/event.dart';

class HistoryEvent extends Event{
  HistoryEvent(int eventId) : super(eventId);
  static final HistoryEvent fetchPastOrdersInfo= HistoryEvent(100);
  static final HistoryEvent fetchCreditTransactions=HistoryEvent(101);
  static final HistoryEvent fetchDebitTransactions=HistoryEvent(102);
  static final HistoryEvent fetchActiveOrder= HistoryEvent(103);
  static final HistoryEvent fetchAddOnsForEachOrder=HistoryEvent(104);
  static final HistoryEvent fetchActiveOrderStatus=HistoryEvent(105);
  static final HistoryEvent fetchBasicPastOrderDetails=HistoryEvent(106);
  static final HistoryEvent fetchCompletePastOrderInfo=HistoryEvent(107);
  static final HistoryEvent getTransactions=HistoryEvent(108);
}