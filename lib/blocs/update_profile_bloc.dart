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
    } else if (event == UpdateProfileEvent.updateEachField) {
      return await updateEachField(message);
    }
    return latestViewModel;
  }


  Future<UpdateProfileModel> fetchBeeDetails() async {
    String query = '''
    {
  profile{
    name{
      firstName
      middleName
      lastName
    }
    email
    phone
    phoneVerified
    altPhone
    personalDetails{
      dateOfBirth
      gender
      fullAddress
    }
  }
}''';
    try {
      Map response = await CustomGraphQLClient.instance.query(query);
      return latestViewModel
        ..firstName = response['profile']['name']['firstName']
        ..middleName = response['profile']['name']['middleName'] ?? ""
        ..lastName = response['profile']['name']['lastName'] ?? ""
        ..emailAddress = response['profile']['email'] ?? ""
        ..phoneNumber = response['profile']['phone']
        ..alternatePhoneNumber = response['profile']['altPhone']
        ..dob = response['profile']['personalDetails']['dateOfBirth'] ?? ""
        ..gender = response['profile']['personalDetails']['gender'] ?? ""
        ..fullAddress=response['profile']['personalDetails']['fullAddress']??""
      ;

    } catch (e) {
      print(e);
    }
    return latestViewModel;
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
    if(event==UpdateProfileEvent.updateEachField)
      latestViewModel..updating=trackFlag;
    return latestViewModel;
  }

  Future<UpdateProfileModel> updateEachField(
      Map<String, dynamic> message) async {
    String query = message['query'];
    try {
      Map response = await CustomGraphQLClient.instance.mutate(query);
      return latestViewModel..updated=true;
    } catch (e) {
      print(e);
      return latestViewModel..updated=false;
    }

  }
}
