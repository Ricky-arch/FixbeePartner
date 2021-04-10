class Excerpt {
  final String rawString;

  List<String> _bulletPoints;
  num _discount;
  String _text;

  List<String> get bulletPoints => _bulletPoints;
  num get discountPercentage => _discount;
  String get text => _text;

  Excerpt(this.rawString) {
    if (rawString != null) _process();
  }

  void _setBulletPoints(String b) {
    if (b != null && _bulletPoints == null) _bulletPoints = b.split('|');
  }

  void _setDiscount(String d) {
    if (d != null && _discount == null) _discount = num.parse(d);
  }

  void _setText(String t) {
    if (t != null && _text == null) _text = t;
  }

  bool _allSet() => _bulletPoints != null && _text != null && _discount != null;

  void _process() {
    RegExp bulletRegEx = new RegExp(
        r'(?:discount *= *(?<d>[0-9]*) *;)|(?:text *= *"(?<t>.*)" *;)|(?:bullet *= *\[(?<b>.*)\] *;)');
    for (RegExpMatch match in bulletRegEx.allMatches(rawString)) {
      String d = match?.namedGroup('d');
      String t = match?.namedGroup('t');
      String b = match?.namedGroup('b');
      _setBulletPoints(b);
      _setDiscount(d);
      _setText(t);
      if (_allSet()) break;
    }
  }
}