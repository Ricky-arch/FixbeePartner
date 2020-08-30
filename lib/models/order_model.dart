import 'package:fixbee_partner/models/view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class OrderModel extends ViewModel{
  String userProfilePicUrl;
  String userFirstname;
  String userMiddlename;
  String userLastname;
  String userRating;
  String userId;
  String serviceName;
  String locationId;
  String locationName;
  String addressLine;
  String googlePlaceId;
  String address;
  String addressName;
  String userPhoneNumber;
  LatLng latLng;
  String otp;
  String serviceId;
  bool priceable;
  int basePrice;
  int serviceCharge;
  int taxPercent;
  String graphQLId;
  String orderId;
  String status;
  bool cashOnDelivery;
  bool slotted;
  DateTime slot;
  String quantity;
  int totalAmount;
  String timeStamp;
}

