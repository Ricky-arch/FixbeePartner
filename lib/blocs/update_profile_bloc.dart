

import 'package:fixbee_partner/events/update_profile_event.dart';
import 'package:fixbee_partner/models/update_profile_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../bloc.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileModel> {
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

  Future<UpdateProfileModel> fetchBeeDetails() async {
    String query = '''
    {Me
  {... 
    on Bee{
  ID
      
  Name{
    Firstname
    Middlename
    Lastname
  }
  Locations{
    ID
    Name
    Address{ Line1
    }
  }
  Email
  DOB  
  
}}}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    List allLocations= response['Me']['Locations'];
    List<Address> locations=[];
    int noOfAddress=0;

    allLocations.forEach((location) {
      Address address= Address();
      address.addressLine=location['Address']['Line1'];
      address.locationId=location['ID'];
      locations.add(address);
    });
    noOfAddress=allLocations.length-1;

    return latestViewModel
      ..firstName = response['Me']['Name']['Firstname']
      ..middleName = response['Me']['Name']['Middlename']??""
      ..lastName = response['Me']['Name']['Lastname']??""
      ..emailAddress = response['Me']['Email']
      ..dob = response['Me']['DOB']..address1=locations[noOfAddress].addressLine;
  }

  Future<UpdateProfileModel> updateBeeDetails(
      Map<String, dynamic> message) async {
    String firstName = message['firstName'],
        middleName = (message['secondName'])??"",
        lastName = message['lastName']??"",
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
}
//AddBankAccount: {
//AccountNumber: "",
//IFSC: "",
//AccountHolderName: ""
//}
