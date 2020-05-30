import 'package:fixbee_partner/models/view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeModel extends ViewModel {
  bool activeStatus= false;
  bool loading = false;

  double latitude;
  double longitude;



//order
  String orderId;
  String amount;
  String serviceId;
  String serviceName;
  String locationName;
  LatLng location;
  String address;
  String landmark;
  String userName;
  String phoneNumber;
  String rating;

}
