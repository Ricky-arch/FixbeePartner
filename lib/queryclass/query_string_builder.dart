class QueryStringBuilder {
  bool mutation;
  String functionName;
  Map _params;
  String _query;
  String _returnFields;

  QueryStringBuilder({this.mutation = false, this.functionName}) {
    _params = Map();
    _returnFields = '';
  }

  void put(String key, Object value, {Map map}) {
    if (map == null) map = _params;
    if (value is Map)
      map[key] = value;
    else if (value is String) map[key] = '"$value"';
  }

  void getBack(String key, {List fields}) {
    if (fields == null)
      _returnFields += '$key ';
    else {
      var fieldsStr = fields.toString().replaceAll(RegExp('\\[|\\]|,'), '');
      _returnFields += '$key{$fieldsStr} ';
    }
  }

  String build() {
    var paramsStr = _params.toString();
    if (paramsStr[0] == '{')
      paramsStr = paramsStr.substring(1, paramsStr.length - 1);
    if (mutation)
      _query = 'mutation{$functionName($paramsStr){$_returnFields}}';
    else
      _query = '{$functionName($paramsStr){$_returnFields}}';
    return _query;
  }
}

void main() {
  Map name = Map();
  Map input = Map();

  QueryStringBuilder queryStringBuilder =
      QueryStringBuilder(mutation: true, functionName: 'addBee');

  String query = (queryStringBuilder
        ..put('Firstname', 'Tamal', map: name)
        ..put('Middlename', 'Kumar', map: name)
        ..put('Lastname', 'Das', map: name)
        ..put('Name', name, map: input)
        ..put('Email', 'tamal8730@gmail.com', map: input)
        ..put('Phone', '8132802897', map: input)
        ..getBack('_id')
        ..getBack('Name', fields: ['Firstname', 'Middlename', 'Lastname']))
      .build();

  print(query);
}
