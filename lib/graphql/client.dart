import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClientProvider {
  static final ClientProvider _instance = ClientProvider._privateConstructor();
  static final HttpLink _httpLink = HttpLink(uri: 'http://fixbee.in/bee/api');
  ValueNotifier<GraphQLClient> _client;

  ClientProvider._privateConstructor() {
    _client = ValueNotifier(GraphQLClient(
      link: _httpLink,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    ));
  }

  static ClientProvider getInstance() {
    return _instance;
  }

  ValueNotifier<GraphQLClient> getGraphQLClient() {
    if (_client == null)
      throw Exception("Access client through ClientProvider instance");
    return _client;
  }
}
