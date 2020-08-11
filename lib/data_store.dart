import 'package:geolocator/geolocator.dart';

import 'models/bee_model.dart';
import 'models/job_model.dart';

class DataStore{
  static String token;
  static Bee me;
  static JobModel user;
  static String fcmToken;
  static Position beePosition;
}