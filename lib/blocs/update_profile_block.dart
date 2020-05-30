import 'package:fixbee_partner/events/update_profile_event.dart';
import 'package:fixbee_partner/models/update_profile_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../bloc.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileModel> {
  UpdateProfileBloc(UpdateProfileModel genesisViewModel)
      : super(genesisViewModel);

  @override
  Future<UpdateProfileModel> mapEventToViewModel(
      UpdateProfileEvent event, Map<String, dynamic> message) async {
    if (event == UpdateProfileEvent.fetchProfile) {
      return await fetchBeeDetails();
    } else if (event == UpdateProfileEvent.updateProfile) {
      return await updateBeeDetails(message);
    }
    return latestViewModel;
  }

  Future<UpdateProfileModel> fetchBeeDetails() async {
    String query='''''';
    Map response= await CustomGraphQLClient.instance.query(query);

    return latestViewModel;
  }

  Future<UpdateProfileModel> updateBeeDetails(Map<String, dynamic> message) async{
    String query='''''';
    Map response= await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }
}
