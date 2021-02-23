import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//0-post
//1-get
class RequestMaker {
  String endpoint;
  Map body;
  int method;
  RequestMaker({@required this.endpoint, this.body, this.method = 0});
  Future<Map> makeRequest() async {
    print('Request: url: $endpoint body: $body');
    if (method == 0) {
      http.Response response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print('response:${response.body}');
      return json.decode(response.body);
    } else {
      http.Response response = await http.get(
        endpoint,
        headers: {'Content-Type': 'application/json'},
      );
      print('response:${response.body}');
      return json.decode(response.body);
    }
  }
}
