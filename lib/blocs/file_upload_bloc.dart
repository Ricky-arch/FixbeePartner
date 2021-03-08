import 'dart:developer';

import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/file_upload_event.dart';
import 'package:fixbee_partner/models/fileModel.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:flutter/material.dart';
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
      return await uploadFile(message['path'], message['file'],
          message['onUpload'], message['tags']);
    if (event == FileUploadEvent.checkUploaded) return await checkUploaded();
    return latestViewModel;
  }

  Future<FileModel> uploadFile(
      String path, String fileName, Function callback, List<String> t) async {
    List tags = t.map((e) {
      return '"$e"';
    }).toList();
    print(tags.toString());
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
        variables: {'file': multipartFile, 'tags': tags.toString()},
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
        if (tags[0][0].toString() != '[') {
          allTags.add(tags[0]);
          keys[tags[0]] = media['key'];
        } else {
          String tag = tags[0].substring(2, tags[0].length - 2);
          keys[tag] = media['key'];
          allTags.add(tag);
        }
      });

      return latestViewModel..uploadedDocuments = allTags..keys=keys;
    } catch (e) {
      print(e);
      return latestViewModel;
    }

    // List<String> uploadedDocuments = [];
    // List<File> files = [];
    // List<Map<String, String>> test = [];
    // Map response = await CustomGraphQLClient.instance.query(query);
    // List documents = response['Me']['Documents'];
    // if (documents.isNotEmpty) {
    //   documents.forEach((document) {
    //     if (document != null) {
    //       Map<String, String> f = {};
    //       f[document['filename']] = document['id'];
    //       File file = File();
    //       file.fileName = document['filename'];
    //       file.fileId = document['id'];
    //       files.add(file);
    //       test.add(f);
    //       uploadedDocuments.add(document['filename'].toString());
    //     }
    //   });
    // }
    // return latestViewModel
    //   ..uploadedDocuments = uploadedDocuments
    //   ..files = files
    //   ..f = test;
  }

  @override
  FileModel setTrackingFlag(
      FileUploadEvent event, bool trackFlag, Map message) {
    if (event == FileUploadEvent.checkUploaded)
      latestViewModel..onFetchUploadedDocumentsList = trackFlag;
    return latestViewModel;
  }
}
