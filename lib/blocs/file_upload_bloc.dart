import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/file_upload_event.dart';
import 'package:fixbee_partner/models/fileModel.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';


class FileUploadBloc extends Bloc<FileUploadEvent, FileModel>
    with Trackable<FileUploadEvent, FileModel> {
  FileUploadBloc(FileModel genesisViewModel) : super(genesisViewModel);
  List<File> files = [];

  @override
  Future<FileModel> mapEventToViewModel(
      FileUploadEvent event, Map<String, dynamic> message) async {
    if (event == FileUploadEvent.uploadFile)
      return await uploadFile(message['path'], message['file'],
          message['onUpload'], message['tags']);
    if (event == FileUploadEvent.checkUploaded) return await checkUploaded();
    return latestViewModel;
  }

  Future<FileModel> uploadFile(
      String path, String fileName, Function callback, String t) async {
    MultipartFile multipartFile = await MultipartFile.fromPath(
      'image',
      path,
      filename: '$fileName.jpg',
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
        variables: {'file': multipartFile, 'tags': ["$t", Constants.DOCUMENTS_TAG]},
      );
      callback();
      return latestViewModel..onErrorUpload = false;
    } catch (e) {
      return latestViewModel..onErrorUpload = true;
    }
  }

  Future<FileModel> checkUploaded() async {
    String query = '''
    {
  medias{
    tags
    key
  }
}
''';
    try {
      Map response = await CustomGraphQLClient.instance.query(query);
      List<String> allTags = [];
      Map<String, String> keys = {};
      List medias = response['medias'];
      medias.forEach((media) {
        List tags = media['tags'];
        allTags.add(tags[0]);
        keys[tags[0]]=media['key'];
      });

      return latestViewModel..uploadedDocuments = allTags..keys=keys;
    } catch (e) {
      print(e);
      return latestViewModel;
    }

  }

  @override
  FileModel setTrackingFlag(
      FileUploadEvent event, bool trackFlag, Map message) {
    if (event == FileUploadEvent.checkUploaded)
      latestViewModel..onFetchUploadedDocumentsList = trackFlag;
    return latestViewModel;
  }
}
