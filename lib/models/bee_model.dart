import 'package:fixbee_partner/models/service_options.dart';

class Bee {
  String id;
  bool verified = false;
  List<ServiceOptionModel> services = [];

  String firstName;
  String middleName;
  String lastName;
  String phoneNumber;
  String alternatePhoneNumber;
  String emailAddress;
  String address;
  String pinCode;
  DateTime dateOfBirth;
  String district;
  String gender;
  String bankAccountNumber;
  String ifscCode;
  String accountHoldersName;
  int walletAmount;
  String myRating;
  int jobsAccepted;
  int jobsDeclined;
  String dpUrl;
  bool active;
  bool blocked;


  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'alternatePhoneNumber': alternatePhoneNumber,
      'emailAddress': emailAddress,
      'address': address,
      'pincode': pinCode,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'bankAccountNumber': bankAccountNumber,
      'ifscCode': ifscCode,
      'accountHoldersName': accountHoldersName,
      'ratings': myRating,
      'jobsAccepted': jobsAccepted,
      'jobsDeclined': jobsDeclined,
    };
  }
}
