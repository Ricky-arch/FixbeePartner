import 'package:fixbee_partner/events/rating_event.dart';
import 'package:fixbee_partner/models/rating_model.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';

import '../bloc.dart';

class RatingBloc extends Bloc<RatingEvent, RatingModel>{
  RatingBloc(RatingModel genesisViewModel) : super(genesisViewModel);

  @override
  Future<RatingModel> mapEventToViewModel(RatingEvent event, Map<String, dynamic> message) async{
    if(event== RatingEvent.addRatingEvent)
      return await addRating(message);
   return latestViewModel;
  }

  Future<RatingModel> addRating(Map<String, dynamic> message) async{
    String accountID = message['accountID'];
    int score = message['Score'];
    String review = message['Review'];

    String query = '''
    mutation{
  AddRating(input:{AccountId:"$accountID", Score:$score, Remark:"$review"}){
    Score
  }
}
    ''';
    Map response = await CustomGraphQLClient.instance.mutate(query);
    return latestViewModel;
  }

}