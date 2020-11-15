class DateTimeFormatter {
  String getDate(String message) {
    return (message.substring(0, 10)).split('-').reversed.join('-');
  }

  String getTime(String message) {
    return message.substring(11, 19);
  }
}
