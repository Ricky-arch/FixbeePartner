import 'package:http/http.dart' as http;

class GraphQlQueryConverter {
  String query;
  bool mutation;
  String url;

  GraphQlQueryConverter(this.mutation, this.query, this.url){
    query = url + '?query=' + query;
  }
  Future<http.Response> post() async {
    try {
      http.Response response = await http.post(query);
      return response;
    } catch (e, _) {
      print(e.toString());
      throw Exception('error');
    }
  }

  Future<http.Response> get() async {
    try {
      http.Response response = await http.get(query);
      return response;
    } catch (e, _) {
      throw Exception('error');
    }
  }

  Future<http.Response> execute() async {
    if (mutation) {
      return await post();
    } else {
      return await get();
    }
  }
}
