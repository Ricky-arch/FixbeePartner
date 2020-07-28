import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/workscreen_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../Constants.dart';
import '../bloc.dart';

class WorkScreenBloc extends Bloc<WorkScreenEvents, WorkScreenModel> {
  WorkScreenBloc(WorkScreenModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<WorkScreenModel> mapEventToViewModel(
      WorkScreenEvents event, Map<String, dynamic> message) async {
    if (event == WorkScreenEvents.fetchOrderDetails) {
      return await fetchOrderDetails(message);
    }
    return latestViewModel;
  }

  Future<WorkScreenModel> fetchOrderDetails(
      Map<String, dynamic> message) async {
    String id = message['order_id'];
    String query = '''{Order(_id:"$id"){
  Location{
    Address{
      Line1
    }
    GooglePlaceID
    Name
  }
  Amount
  OTP
  Service{
    Name
    ID
  }
  CashOnDelivery
  Timestamp
  User{
    ID
    Name{
      Firstname
      Middlename
      Lastname
    }
    DisplayPicture{
      filename
      mimetype
      encoding
    }
    Ratings{
      Score
    }
    Phone{
      Number
    }
  }
}}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    Map order = response['Order'];
    Map user = order['User'];
    Map location = order['Location'];
    print(location['Address']['Line1']+"llll");

    return latestViewModel
      ..jobModel.userFirstname = user['Name']["Firstname"]
      ..jobModel.userMiddlename = user['Name']["Middlename"]
      ..jobModel.userLastname = user['Name']["Lastname"]
      ..jobModel.userPhoneNumber = user['Phone']['Number']
      ..jobModel.serviceName = response['Order']['Service']["Name"]
      ..jobModel.address = location['Address']['Line1']
      ..jobModel.googlePlaceId = location['GooglePlaceID']
      ..jobModel.userProfilePicUrl = '${EndPoints.DOCUMENT}?id=${user['DisplayPicture']['id']}'
      ..jobModel.totalAmount = order['Amount']
      ..jobModel.cashOnDelivery = order['CashOnDelivery']
      ..jobModel.timeStamp = order['Timestamp'];
  }

}
