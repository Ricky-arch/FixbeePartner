import 'package:fixbee_partner/models/view_model.dart';

class CustomProfileModel extends ViewModel {
  String imageUrl;
  String imageId;
  String filename;
  String mimetype;
  String encoding;
  bool verifiedAccount=false;
  bool dpUploaded=false;
  bool whileUploadingDp=false;
}
