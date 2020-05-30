import 'package:fixbee_partner/data_provider/parcelable.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/model.dart';
import 'data_provider.dart';

abstract class EventToModelMappable<E extends Event, M extends Model>
    extends DataProvider<M> {
  EventToModelMappable(M model) : super(model);
  Parcelable mapEventToModel(Parcelable eventParcel, M prevModel);
}
