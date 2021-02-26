import 'dart:developer';

import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/update_profile_event.dart';
import 'package:fixbee_partner/models/update_profile_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../bloc.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileModel>
    with Trackable<UpdateProfileEvent, UpdateProfileModel> {
  UpdateProfileBloc(UpdateProfileModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<UpdateProfileModel> mapEventToViewModel(
      UpdateProfileEvent event, Map<String, dynamic> message) async {
    if (event == UpdateProfileEvent.fetchProfile) {
      return await fetchBeeDetails();
    } else if (event == UpdateProfileEvent.updateProfile) {
      return await updateBeeDetails(message);
    }
    return latestViewModel;
  }

//   {
//   profile{
//   name{
//   firstName
//   middleName
//   lastName
// }
// email
// personalDetails{
// dateOfBirth
// gender
// }
// }
// }

  Future<UpdateProfileModel> fetchBeeDetails() async {
    String query = '''
    {
  profile{
    name{
      firstName
      middleName
      lastName
    }
    personalDetails{
      dateOfBirth
      gender
    }
    displayPicture
    email
    phone
  }
}''';

    Map response = await CustomGraphQLClient.instance.query(query);
    // try{
    //   List allLocations = response['profile']['locations'];
    //   List<Address> locations = [];
    //   int noOfAddress = 1;
    //
    //   allLocations.forEach((location) {
    //     Address address = Address();
    //     address.addressLine = location['Address']['Line1'];
    //     address.locationId = location['ID'];
    //     locations.add(address);
    //   });
    //   noOfAddress = allLocations.length - 1;
    //   latestViewModel..address1 = locations[noOfAddress].addressLine;
    // }
    // catch(e){
    //   log(e.toString(), name:"Account Error");
    // }
    return latestViewModel
      ..firstName = response['profile']['name']['firstName']
      ..middleName = response['profile']['name']['middleName'] ?? ""
      ..lastName = response['profile']['name']['lastName'] ?? ""
      ..emailAddress = response['me']['email']
      ..dob = response['me']['dob']
      ..gender = response['gender'];
  }

  Future<UpdateProfileModel> updateBeeDetails(
      Map<String, dynamic> message) async {
    String firstName = message['firstName'],
        middleName = (message['middleName']) ?? "",
        lastName = message['lastName'] ?? "",
        email = message['email'],
        address = message['address'],
        pinCode = message['pin-code'],
        dob = message['dateOfBirth'],
        gender = message['gender'];
    String query = '''mutation {
  Update(input: {
    Name: {
      Firstname: "$firstName",
      Middlename: "$middleName",
      Lastname: "$lastName"
    },
    AddLocation: {
    Name:"Location1"
      Address: {
        Line1:"$address"
      }
    },
    DOB: "$dob",
    Email: "$email",
    Gender: "$gender",
  
  }) {
    ...on Bee {
      ID
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

  @override
  UpdateProfileModel setTrackingFlag(
      UpdateProfileEvent event, bool trackFlag, Map message) {
    if (event == UpdateProfileEvent.fetchProfile)
      latestViewModel..loading = trackFlag;
    return latestViewModel;
  }
}
