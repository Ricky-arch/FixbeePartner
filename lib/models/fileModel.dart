import 'package:fixbee_partner/models/view_model.dart';

class FileModel extends ViewModel{
 List <File> files= [];
 File file= File();
 Map<String, String> keys={};
 int numberOfFiles;
  bool aadhaarUploaded=false;
  bool ageProofUploaded=false;
  bool addressProofUploaded=false;
  bool additionalCertificateUploaded=false;
  bool onErrorUpload=false;
  List<String> uploadedDocuments=[];
  bool onFetchUploadedDocumentsList=false;
 String fileUrl;
 String fileId;
 String filePath;
 String fileName;
 String mimetype;
 String tag;
 String key;
 String encoding;
}
class File extends ViewModel{
  String fileUrl;
  String fileId;
  String filePath;
  String fileName;
  String mimetype;
  List<String> tag=[];
  String key;
  String encoding;
}