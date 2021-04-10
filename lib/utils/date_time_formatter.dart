class DateTimeFormatter {
  DateTime _dateTime;
  DateTime get dateTime => _dateTime;

  DateTimeFormatter();

  String getDate(String message) {
    DateTime element = DateTime.tryParse(message);
    String value = element.toLocal().toString();
    return (value.substring(0, 10)).split('-').reversed.join('-');
  }

  String getTime(String message) {
    DateTime element = DateTime.tryParse(message);
    String value = element.toLocal().toString();
    return value.substring(11, 19);
  }

  DateTimeFormatter.parse(String timeStamp) {
    _dateTime = DateTime.tryParse(timeStamp);
    if (_dateTime == null) {
      _dateTime = DateTime.fromMillisecondsSinceEpoch(num.parse(timeStamp));
    }
    //_dateTime = _dateTime.toLocal();
  }

  String get formattedDate =>
      '${_dateTime.day}-${_dateTime.month}-${_dateTime.year}';

  String get formattedTime =>
      '${_dateTime.hour}:${_dateTime.minute}:${_dateTime.second}';
}
