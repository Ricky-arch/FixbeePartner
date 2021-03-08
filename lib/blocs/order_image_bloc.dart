import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/blocs/flavours.dart';
import 'package:fixbee_partner/events/order_image_event.dart';
import 'package:fixbee_partner/models/order_images_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

class OrderImageBloc extends Bloc<OrderImageEvent, OrderImagesModel>
    with Trackable<OrderImageEvent, OrderImagesModel> {
  OrderImageBloc(OrderImagesModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<OrderImagesModel> mapEventToViewModel(
      OrderImageEvent event, Map<String, dynamic> message) async {
    // if (event == OrderImageEvent.getImageIds) {
    //   return getImageIds();
    // }
    return latestViewModel;
  }

  Future<List<String>> getImageIds() async {
    String query = '''
    {
  activeOrder{
    hasUploads
    uploads
  }
}
    ''';

    Map response = await CustomGraphQLClient.instance.query(query);
    if (response['activeOrder']['hasUploads']) {
      List ids = response['activeOrder']['uploads'];
      List<String> imageIds = [];
      ids.forEach((id) {
        String i = id.toString();
        imageIds.add(i);
      });
      return imageIds;
    }
    return [];
  }

  @override
  OrderImagesModel setTrackingFlag(
      OrderImageEvent event, bool trackFlag, Map message) {
    if (event == OrderImageEvent.getImageIds)
      return latestViewModel..fetching = trackFlag;
    // TODO: implement setTrackingFlag
    throw UnimplementedError();
  }
}
