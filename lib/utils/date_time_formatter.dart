class DateTimeFormatter {

  String getDate(String message) {
    DateTime element= DateTime.tryParse(message);
    String value= element.toLocal().toString();
    return (value.substring(0, 10)).split('-').reversed.join('-');
  }

  String getTime(String message) {
    DateTime element= DateTime.tryParse(message);
    String value= element.toLocal().toString();
    return value.substring(11, 19);
  }
}
