import 'dart:developer';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/file_upload_event.dart';
import 'package:fixbee_partner/models/fileModel.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../Constants.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileModel>
    with Trackable<FileUploadEvent, FileModel> {
  FileUploadBloc(FileModel genesisViewModel) : super(genesisViewModel);
  List<File> files = [];

  @override
  Future<FileModel> mapEventToViewModel(
      FileUploadEvent event, Map<String, dynamic> message) async {
    if (event == FileUploadEvent.uploadFile)
      return await uploadFile(
          message['path'], message['file'], message['onUpload']);
    if (event == FileUploadEvent.checkUploaded) return await checkUploaded();
    return latestViewModel;
  }

  Future<FileModel> uploadFile(
      String path, String fileName, Function callback) async {
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

    log('OnUPLOAD', name: 'onUp4');
    callback();

    print(response);
    if (response.containsKey("errors")) {
      return latestViewModel..onErrorUpload = true;
    } else
      latestViewModel.onErrorUpload = false;
    List documents = response['Update']['Documents'];
    latestViewModel..numberOfFiles = response.length;
    documents.forEach((document) {
      File file = File();
      file.fileName = document['filename'];
      file.fileId = document['id'];
      files.add(file);
    });
    return latestViewModel..files = files;
  }

  Future<FileModel> checkUploaded() async {
    String query = '''
    {
  Me {
    ... on Bee {
      Documents {
        filename

      }
    }
  }
}
''';
    List<String> uploadedDocuments = [];
    Map response = await CustomGraphQLClient.instance.query(query);
    List documents = response['Me']['Documents'];
    if (documents.isNotEmpty) {
      documents.forEach((document) {
        if (document != null)
          uploadedDocuments.add(document['filename'].toString());
      });
    }
    return latestViewModel..uploadedDocuments = uploadedDocuments;
  }

  @override
  FileModel setTrackingFlag(
      FileUploadEvent event, bool trackFlag, Map message) {
    if (event == FileUploadEvent.checkUploaded)
      latestViewModel..onFetchUploadedDocumentsList = trackFlag;
    return latestViewModel;
  }
}
