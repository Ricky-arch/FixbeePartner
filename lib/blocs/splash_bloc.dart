import 'dart:developer';

import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/models/splash_model.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_store.dart';

class SplashBloc extends Bloc<Event, SplashModel> {
  SplashBloc(ViewModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<SplashModel> mapEventToViewModel(
      Event event, Map<String, dynamic> message) async {
    log('Splash');
    return await _fetchToken();
  }

  Future<SplashModel> _fetchToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(SharedPrefKeys.TOKEN)) {
      String token = pref.getString(SharedPrefKeys.TOKEN);
      log(token, name: 'TOKEN');
      DataStore.token = token;
      Bee bee = await _checkToken(token);
      return latestViewModel
        ..me = bee
        ..tokenFound = true;
    }
    return latestViewModel..tokenFound = false;
  }

  Future<Bee> _checkToken(String token) async {
    String query = '''
    {
          Me{
            ... on Bee{
            Services{
        ID
        Name
      }
              Name{
                Firstname
                Middlename
                Lastname
              }
              Phone{
                Number
                Verified
              }      
            }
          }
        }
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);

    Map name = response['Me']['Name'];
    Map phone = response['Me']['Phone'];
    List services = response['Me']['Services'];

    Bee bee = Bee()
      ..firstName = name['Firstname']
      ..middleName = name['Middlename'] ?? ''
      ..lastName = name['Lastname'] ?? ''
      ..phoneNumber = phone['Number']
      ..verified = phone['Verified']
      ..services = services.map((service) {
        return ServiceOptionModel()
          ..id = service['ID']
          ..serviceName = service['Name'];
      }).toList();

    DataStore.me = bee;

    return bee;
  }
}
