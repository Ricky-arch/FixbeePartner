import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/models/view_model.dart';

class UpdateProfileModel extends ViewModel{
  bool loading=false;
  List<Address> addresses=[];
  int id;
  bool verified = false;
  String firstName;
  String middleName;
  String lastName;
  String phoneNumber;
  String alternatePhoneNumber;
  String emailAddress;
  String address1;
  String address2;
  String pinCode;
  String dob;
  DateTime dateOfBirth;
  String district;
  String gender;
}
class Address{
  String locationId;
  String landmark;
  String addressLine;
  String googlePlaceId;
  String userRating;
}