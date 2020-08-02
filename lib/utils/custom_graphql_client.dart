import 'dart:developer';

import 'package:graphql/client.dart';

import '../Constants.dart';
import '../data_store.dart';

class CustomGraphQLClient {
  HttpLink _link;
  GraphQLClient _graphQLClient;
  static CustomGraphQLClient _instance;
  GraphQLClient _wsClient;

  GraphQLClient get wsClient {
    if (_wsClient == null) {
      WebSocketLink wsLink = WebSocketLink(
          url: EndPoints.GRAPHQL_WS,
          config: SocketClientConfig(autoReconnect: true));

      _wsClient = GraphQLClient(
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
          link: wsLink);
    }
    return _wsClient;
  }

  void invalidateWSClient() {
    if (_wsClient == null) return;
    (_wsClient.link as WebSocketLink)?.dispose();
    _wsClient = null;
  }
  void invalidateClient(){
    _instance=null;
  }

  CustomGraphQLClient._privateConstructor() {
    if (DataStore.token == null) {
      print('Set user token to datastore first');
    }

    _link = HttpLink(
        uri: EndPoints.GRAPHQL, headers: {'authorization': DataStore.token});


    _graphQLClient = GraphQLClient(
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
        link: _link);
  }

  static CustomGraphQLClient get instance {
    if (_instance == null)
      _instance = CustomGraphQLClient._privateConstructor();
    return _instance;
  }

  Future<Map> query(String queryString) async {
    log('auth:${DataStore.token}\n$queryString',name: 'QUERY');
    QueryOptions options = QueryOptions(
        documentNode: gql(queryString),
        fetchPolicy: FetchPolicy.cacheAndNetwork);
    QueryResult result = await _graphQLClient.query(options);
    if (result.hasException) {
      log('${result.exception}', time: DateTime.now(), name: 'ERROR');
      throw Exception(result.exception.toString());
    }
    log('${result.data as Map}', time: DateTime.now(), name: 'Response');
    return result.data as Map;
  }

  Future<Map> mutate(String queryString, {var variables}) async {
    log(queryString, name: "MUTATION GQL");
    MutationOptions options;
    if (variables != null)
      options =
          MutationOptions(documentNode: gql(queryString), variables: variables);
    else
      options = MutationOptions(documentNode: gql(queryString));
    QueryResult result = await _graphQLClient.mutate(options);
    if (result.hasException) {
      log(result.exception.toString(), name: 'ERROR MUTATION');
      throw (result.exception.toString());
    }
    log((result.data as Map).toString(), name: "RESPONSE GQL");
    return result.data as Map;
  }
  Stream<FetchResult> subscribe(GraphQLClient wsClient, String queryString) {
    Operation operation = Operation(documentNode: gql(queryString));
    return wsClient.subscribe(operation);
  }
}
