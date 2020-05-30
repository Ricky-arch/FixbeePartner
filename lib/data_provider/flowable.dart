import 'package:fixbee_partner/data_provider/parcelable.dart';

abstract class Flowable {}

abstract class CanFetch implements Flowable {
  Future<Parcelable> fetch(Parcelable eventParcel);
}

abstract class CanSave implements Flowable {
  Future<Parcelable> save(Parcelable eventParcel);
}

abstract class CanUpdate implements Flowable {
  Future<Parcelable> update(Parcelable eventParcel);
}
