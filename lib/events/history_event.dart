import 'package:fixbee_partner/events/event.dart';

class HistoryEvent extends Event{
  HistoryEvent(int eventId) : super(eventId);
  static final HistoryEvent fetchPastOrders= HistoryEvent(100);
  static final HistoryEvent fetchCreditTransactions=HistoryEvent(101);
  static final HistoryEvent fetchDebitTransactions=HistoryEvent(102);
  static final HistoryEvent fetchActiveOrder= HistoryEvent(103);
  static final HistoryEvent fetchAddOnsForEachOrder=HistoryEvent(104);

}