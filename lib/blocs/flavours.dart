import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/view_model.dart';

mixin Trackable<E extends Event, M extends ViewModel> {
  M setTrackingFlag(E event, bool trackFlag, Map message);
}

mixin SecondaryStreamable<M extends ViewModel> {
  M mapSubResultToModel(Map result);
  void onExtinguish();
}