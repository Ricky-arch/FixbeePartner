import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/home_events.dart';
import 'package:fixbee_partner/models/home_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'flavours.dart';

class HomeBloc extends Bloc<HomeEvents, HomeModel>
    with Trackable<HomeEvents, HomeModel>, SecondaryStreamable<HomeModel> {
  //String token="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoiYmVlIiwiX2lkIjoiNWU0MmI4YTg2YTYxYjMwMDFlMWQyMTM4IiwiaWF0IjoxNTgxNDMxMDg3LCJleHAiOjE1ODQwMjMwODcsImF1ZCI6IkZJWEJFRSIsImlzcyI6IkZJWEJFRSIsInN1YiI6IiJ9.PK_9WC8-Qa1pz1OKosCb58sBxtPW62YndFmaH7cQ4LhsktP5dr1IT0fS7RA8qER3FQQBqQonuj01C6aCM6t2jrrnmon45IyPwMJX81i5Y-5JMvbsvVYG-r3DNa_0ec9o4lnxaVLTTp_wdEFxTb85FHNw4wnqRA8JsigYW0PpnDA";
  HomeBloc(HomeModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<HomeModel> mapEventToViewModel(
      HomeEvents event, Map<String, dynamic> message) async {
    if (event == HomeEvents.activityStatusSet) {
      return await _setActivityStatus(message);
    } else if (event == HomeEvents.activityStatusRequested) {
      return await _getActivityStatus();
    } else if (event == HomeEvents.updateLiveLocation) {
      return await updateLiveLocation(message);
    } else if (event == HomeEvents.getLiveLocation) {
      return await getLiveLocation();
    }

    return latestViewModel;
  }

  Future<HomeModel> _setActivityStatus(Map<String, dynamic> message) async {
    bool status = message['status'];
    String query = '''mutation{
  Update(input:{SetActive:$status}){
    ... on Bee{
      Active
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);

    return latestViewModel
      ..activeStatus = response['Update']['Active'] ?? false;
  }

  Future<HomeModel> _getActivityStatus() async {
    String query = '''{
  Me{
    ... on Bee{
      Active
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);

    return latestViewModel..activeStatus = response['Me']['Active'];
  }

  Future<HomeModel> updateLiveLocation(Map<String, dynamic> message) async {
    double latitude = message['latitude'];
    double longitude = message['longitude'];
    String query = '''mutation {
  Update(input:{UpdateLiveLocation:{Latitude: $latitude, Longitude: $longitude}}){
    ... on Bee{
      ID
      LiveLocation{
        Latitude
        Longitude
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel
      ..latitude = response['Update']['LiveLocation']['Latitude']
      ..latitude = response['Update']['LiveLocation']['Longitude'];
  }

  @override
  HomeModel setTrackingFlag(HomeEvents event, bool loading, Map message) {
    if (event == HomeEvents.activityStatusSet ||
        event == HomeEvents.activityStatusRequested) {
      return latestViewModel..loading = loading;
    }
    return latestViewModel;
  }

  subscribeToNotifications() {
    String query = '''
    subscription{
  OrderRequest{
    ID
    OrderId
    Amount
    Service{
      ID
      Name
    }
    Location{
      ID
      Name
      Geolocation{
        Latitude
        Longitude
      }
      Address{
        Line1
        Line2
        Landmark
      }
    }
    User{
      Name{
        Firstname
        Middlename
        Lastname
      }
      Phone{
        Number
      }
      Ratings{
        Score
      }
    }
  }
}
    ''';

    Stream<FetchResult> sub = CustomGraphQLClient.instance
        .subscribe(CustomGraphQLClient.instance.wsClient, query);




    addSecondaryStream(sub);
  }

  @override
  HomeModel mapSubResultToModel(Map result) {


    return latestViewModel;
  }

  @override
  void onExtinguish() {
    CustomGraphQLClient.instance.invalidateWSClient();
  }

  Future<HomeModel> getLiveLocation() async {
    String query = '''{
  Me{
    ...on Bee{
      LiveLocation{
        Latitude
        Longitude
      }
    }
  }
}''';
    Map response= await CustomGraphQLClient.instance.query(query);
    return latestViewModel
      ..latitude = response['Me']['LiveLocation']['Latitude']??	23.829321
      ..latitude = response['Me']['LiveLocation']['Longitude']??91.277847;
  }
}
