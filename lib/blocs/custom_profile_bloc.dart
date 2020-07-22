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
      return await updateDP(message['path'], message['file']);
    }
    if (event == CustomProfileEvent.downloadDp) return await downloadDp();
    return latestViewModel;
  }

  Future<CustomProfileModel> updateDP(String path, String filename) async {
    MultipartFile multipartFile = await MultipartFile.fromPath(
      'image',
      path,
      filename: '$filename.jpg',
      contentType: MediaType("image", "jpg"),
    );

    String query = r'''
  mutation($file: Upload!){
      Update(input:{UpdateDisplayPicture:$file}){
        ... on Bee{
          DisplayPicture{
            id
          }
        }
      }
  }
  ''';

    Map response = await CustomGraphQLClient.instance.mutate(
      query,
      variables: {'file': multipartFile},
    );

    if (response.containsKey('Update')) {
      String id = response['Update']['DisplayPicture']['id'];
      String _imageURL = '${EndPoints.DOCUMENT}?id=$id';
      print("xxx:" + id);
      print("imageUrl" + _imageURL);
      return latestViewModel..imageUrl = _imageURL;
    } else
      return latestViewModel;
  }

  Future<CustomProfileModel> downloadDp() async {
    String query = '''{
  Me{
    ... on Bee{
      ID
      DisplayPicture{
        filename
        mimetype
        id
        encoding
      }
    }
  }
}''';
    Map response = await CustomGraphQLClient.instance.query(query);
    String id = response['Me']['DisplayPicture']['id'];
    print("xxx" + id);
    return latestViewModel
      ..imageId = response['Me']['DisplayPicture']['id']
      ..imageUrl = '${EndPoints.DOCUMENT}?id=$id';
  }
}
