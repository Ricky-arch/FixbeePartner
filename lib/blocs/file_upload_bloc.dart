import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/file_upload_event.dart';
import 'package:fixbee_partner/models/fileModel.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../Constants.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileModel> {
  FileUploadBloc(FileModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<FileModel> mapEventToViewModel(
      FileUploadEvent event, Map<String, dynamic> message) async {
    if (event == FileUploadEvent.uploadFile)
      return await uploadFile(message['path'], message['file']);
    return latestViewModel;
  }

  Future<FileModel> uploadFile(String path, String fileName) async {
    MultipartFile multipartFile = await MultipartFile.fromPath(
      'image',
      path,
      filename: '$fileName.jpg',
      contentType: MediaType("image", "jpg"),
    );

    String query = r'''
  mutation($file: Upload!){
      Update(input:{AddDocument:$file}){
        ... on Bee{
          Documents{
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
      String id = response['Update']['Document']['id'];
      String _fileUrl = '${EndPoints.DOCUMENT}?id=$id';
      print("xxx:" + id);
      print("imageUrl" + _fileUrl);
      return latestViewModel
        ..fileUrl = _fileUrl
        ..fileName = fileName;
    } else
      return latestViewModel;
  }
}
