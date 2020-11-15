import 'package:fixbee_partner/models/view_model.dart';

class FileModel extends ViewModel{
 List <File> files= [];
 int numberOfFiles;
  bool aadhaarUploaded=false;
  bool ageProofUploaded=false;
  bool addressProofUploaded=false;
  bool additionalCertificateUploaded=false;
  bool onErrorUpload=false;
  List<String> uploadedDocuments=[];
  bool onFetchUploadedDocumentsList=false;
}
class File extends ViewModel{
  String fileUrl;
  String fileId;
  String filePath;
  String fileName;
  String mimetype;
  String encoding;
}