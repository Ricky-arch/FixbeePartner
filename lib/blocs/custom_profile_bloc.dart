import 'dart:math';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/custom_profile_event.dart';
import 'package:fixbee_partner/models/custom_profile_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../Constants.dart';

class CustomProfileBloc extends Bloc<CustomProfileEvent, CustomProfileModel> {
  CustomProfileBloc(CustomProfileModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<CustomProfileModel> mapEventToViewModel(
      CustomProfileEvent event, Map<String, dynamic> message) async {
    if (event == CustomProfileEvent.updateDp) {
      return await updateDP(message['path'], message['file'], message['tags']);
    }
    if (event == CustomProfileEvent.downloadDp) return await downloadDp();
    if (event == CustomProfileEvent.checkForVerifiedAccount)
      return await checkForVerifiedAccount();
    if (event == CustomProfileEvent.deactivateBee) return await deactivateBee();
    return latestViewModel;
  }

  Future<CustomProfileModel> updateDP(
      String path, String filename, List<String> t) async {
    List tags = t.map((e) {
      return '"$e"';
    }).toList();
    MultipartFile multipartFile = await MultipartFile.fromPath(
      'image',
      path,
      filename: '$filename.jpg',
      contentType: MediaType("image", "jpg"),
    );

    String query = r'''
mutation($file: Upload!, $tags: [String]) {
  createMedia(input: { file: $file, tags: $tags }) {
    key
    filename
    tags
  }
}
  ''';

    try {
      Map response = await CustomGraphQLClient.instance.mutate(
        query,
        variables: {'file': multipartFile, 'tags': tags.toString()},
      );
      String key = response['createMedia']['key'];
      String mutate = '''mutation{
              update(input:{displayPicture:"$key"}){
                displayPicture
              }
            }''';
      try {
        Map responseOfMutation =
            await CustomGraphQLClient.instance.mutate(mutate);

        return latestViewModel..imageUrl = '${EndPoints.DOCUMENT}$key';
      } catch (e) {}
      print(e);
      return latestViewModel;
    } catch (e) {
      print(e);
      return latestViewModel;
    }
  }

  Future<CustomProfileModel> downloadDp() async {
    String query = '''{
  profile{
    displayPicture
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    String key = response['profile']['displayPicture'];

    if (key != null) {
      return latestViewModel
        ..imageId = response['profile']['displayPicture']
        ..imageUrl = '${EndPoints.DOCUMENT}$key';
    }

    return latestViewModel;
  }

  Future<CustomProfileModel> checkForVerifiedAccount() async {
    String query = '''
    {
      profile{
        documentsVerified
      }
    }
    ''';
    Map response = await CustomGraphQLClient.instance.query(query);

    return latestViewModel
      ..verifiedAccount = response['profile']['documentsVerified'];
  }

  Future<CustomProfileModel> deactivateBee() async {
    bool deactivate = false;
    String query = '''mutation{
  update(input:{active:$deactivate}){
    active
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    return latestViewModel;
  }
}
