import 'package:fixbee_partner/models/model.dart';

abstract class DataProvider<M extends Model> {
  M model;
  DataProvider(this.model);
}
