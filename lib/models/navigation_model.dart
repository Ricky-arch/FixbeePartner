import 'package:fixbee_partner/models/view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'orders_model.dart';

class NavigationModel extends ViewModel {
  bool gotJob = false;
  String jobId;
  bool onJobConfirmed=false;
  bool isOrderActive=false;

  User user = User();
  Service service=Service();
  Order order=Order();
  Location location=Location();
  bool loading=false;
  bool orderExpired=false;
  Orders ordersModel = Orders();
  List<OrderNotificationModel> orderNotifications=[];
}


class User {
  String userId;
  String firstname;
  String middlename;
  String lastname;
  String phoneNumber;
  String profilePicUrl;
  String profilePicId;
  double userRating;
}
class Location{
  String locationId;
  String landmark;
  String addressLine;
  String googlePlaceId;
  String userRating;
  double latitude;
  double longitude;
}

class Service {
  String serviceId;
  String serviceName;
  bool priceable;
  int basePrice;
  int serviceCharge;
  int taxPercent;
  int amount;
  int addOnBasePrice;
  int addOnTaxCharge;
  int addOnServiceCharge;
  int quantity;
}

class Order {
  String graphQLId;
  String orderId;
  String status;
  bool cashOnDelivery;
  bool slotted;
  String slottedAt;
  int quantity;
  String otp;
  String timeStamp;
  int price;
  int basePrice;
  int serviceCharge;
  int taxPercent;
  int orderBasePrice;
  int orderServiceCharge;
  int orderDiscount;
  int orderTaxCharge;
  int orderAmount;

}

class OrderNotificationModel{
  bool cashOnDelivery;
  String userName, serviceName, orderId, orderAddress;
}