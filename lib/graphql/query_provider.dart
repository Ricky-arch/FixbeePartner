import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class QueryProvider extends StatefulWidget {
  final ValueNotifier<GraphQLClient> client;
  final Function whileLoading;
  final Function(String) onError;
  final Function(LazyCacheMap) onSuccess;
  final String query;

  const QueryProvider(this.client,
      {this.whileLoading, this.onError, this.onSuccess, @required this.query});
  @override
  _QueryProviderState createState() => _QueryProviderState();
}

class _QueryProviderState extends State<QueryProvider> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: widget.client,
      child: Query(
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return widget.whileLoading();
          }
          if (result.data != null) {
            return widget.onSuccess(result.data);
          }
          return widget.onError(result.exception.toString());
        },
        options: QueryOptions(documentNode: gql(widget.query)),
      ),
    );
  }
}
