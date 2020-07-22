import 'package:fixbee_partner/models/view_model.dart';

class FileModel extends ViewModel{
 List <File> files= [];
 int numberOfFiles;
}
class File extends ViewModel{
  String fileUrl;
  String fileId;
  String filePath;
  String fileName;
  String mimetype;
  String encoding;
}