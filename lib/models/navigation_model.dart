import 'package:fixbee_partner/models/view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationModel extends ViewModel {
  bool gotJob = false;
  String jobId;
  bool onJobConfirmed=false;

  User user = User();
  Service service=Service();
  Order order=Order();
  Location location=Location();
}

class User {
  String userId;
  String firstname;
  String middlename;
  String lastname;
  String phoneNumber;
  String profilePicUrl;
  String profilePicId;

}
class Location{
  String locationId;
  String landmark;
  String addressLine;
  String googlePlaceId;
  String userRating;
}

class Service {
  String serviceId;
  String serviceName;
  bool priceable;
  int basePrice;
  int serviceCharge;
  int taxPercent;
}

class Order {
  String graphQLId;
  String orderId;
  String status;
  bool cashOnDelivery;
  bool slotted;
  DateTime slottedAt;
  String quantity;
  String otp;
  String timeStamp;
  int price;
}
