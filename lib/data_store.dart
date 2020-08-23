import 'package:geolocator/geolocator.dart';

import 'models/bee_model.dart';
import 'models/order_model.dart';

class DataStore{
  static String token;
  static Bee me;
  static OrderModel orderModel;
  static String fcmToken;
  static Position beePosition;
}