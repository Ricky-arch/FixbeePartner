
import 'package:fixbee_partner/models/view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationModel extends ViewModel{
  bool gotJob=false;
  String serviceName;
  String address;
  String landmark;
  String userPhoneNumber;
  LatLng latLng;
  String otp;
}