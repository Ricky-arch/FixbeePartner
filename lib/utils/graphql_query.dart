import 'dart:convert';

import 'package:http/http.dart' as http;

class GraphQlQuery {
  String query;
  bool mutation;
  String url;
  Map<String, String> headers;

  GraphQlQuery(this.url, this.mutation, this.query, {this.headers}) {
    query = url + '?query=' + query;
  }

  Future<http.Response> _post() async {
    if (headers == null)
      return await http.post(query);
    else
      return await http.post(query, headers: headers);
  }

  Future<http.Response> _get() async {
    if (headers == null)
      return await http.get(query);
    else
      return await http.get(query, headers: headers);
  }

  Future<Map> execute() async {
    var method;
    if (mutation)
      method = _post;
    else
      method = _get;
    http.Response response = await method();
    print('Response : ${response.body}');
    return json.decode(response.body);
  }
}
