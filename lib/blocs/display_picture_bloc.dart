import 'package:fixbee_partner/events/display_picture_event.dart';
import 'package:fixbee_partner/models/display_picture_model.dart';

import '../bloc.dart';

class DisplayPictureBloc
    extends Bloc<DisplayPictureEvent, DisplayPictureModel> {
  DisplayPictureBloc(DisplayPictureModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<DisplayPictureModel> mapEventToViewModel(
      DisplayPictureEvent event, Map<String, dynamic> message) async {
    if (event == DisplayPictureEvent.downloadDisplayPicture)
      return await downloadDisplayPicture(message);
    if (event == DisplayPictureEvent.uploadDisplayPicture)
      return await uploadDisplayPicture(message);
    return latestViewModel;
  }

  Future<DisplayPictureModel> downloadDisplayPicture(
      Map<String, dynamic> message) async {
    return latestViewModel;
  }

  Future<DisplayPictureModel> uploadDisplayPicture(
      Map<String, dynamic> message) async {
    return latestViewModel;
  }
}
