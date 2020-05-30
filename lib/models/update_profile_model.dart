import 'package:fixbee_partner/models/view_model.dart';

class UpdateProfileModel extends ViewModel{
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
  DateTime dateOfBirth;
  String district;
  String gender;
}