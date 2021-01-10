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
  String ratings;
  int jobsAccepted;
  int jobsDeclined;
  String dpUrl;
  bool active;

//  Bee(this.id, this.firstName, this.middleName ,this.lastName, this.phoneNumber, this.emailAddress, this.address, this.pinCode, this.dateOfBirth, this.district, this.gender, this.bankAccountNumber, this.ifscCode, this.accountHoldersName, this.ratings, this.walletValue, this.jobsAccepted, this.jobsDeclined);

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
      'ratings': ratings,
      'jobsAccepted': jobsAccepted,
      'jobsDeclined': jobsDeclined,
    };
  }
}
