import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../../Constants.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController controller;

  const DatePicker({Key key, @required this.controller}) : super(key: key);
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final format = DateFormat("yyyy-MM-dd");
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: widget.controller,
      validator: (value) {
        if (value.toIso8601String().isEmpty) {
          return 'Please Enter Your Date of Birth';
        }
        return null;
      },
      style: TextStyle(
          color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide.none),
        errorStyle: TextStyle(
            color: Theme.of(context).errorColor, fontWeight: FontWeight.bold),
        errorText: "Your age must be above 18 years",
        fillColor: Theme.of(context).cardColor,
        filled: true,
        labelText: "Date of Birth*",
        labelStyle: TextStyle(
            color: Theme.of(context).hintColor, fontWeight: FontWeight.bold),
      ),
      format: format,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            builder: (BuildContext context, Widget child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme:
                      ColorScheme.light(primary: PrimaryColors.backgroundColor),
                  focusColor: Colors.yellow,
                  backgroundColor: Colors.yellow,
                  buttonTheme: ButtonThemeData(buttonColor: Colors.black),
                ),
                child: child,
              );
            },
            context: context,
            firstDate: DateTime(1950),
            initialDate:
                currentValue ?? _currentDate.subtract(Duration(days: 365 * 18)),
            lastDate: _currentDate.subtract(Duration(days: 365 * 18)));
      },
    );
  }
}
