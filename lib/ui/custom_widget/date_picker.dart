import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
class DatePicker extends StatefulWidget {
  final TextEditingController controller;

  const DatePicker({Key key,@required this.controller}) : super(key: key);
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final format = DateFormat("yyyy-MM-dd");
  DateTime _currentDate= DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[

      DateTimeField(

        controller: widget.controller,
        validator: (value) {
          if (value.toIso8601String().isEmpty) {
            return 'Please Enter Your Date of Birth';
          }
          return null;
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
        labelText: "Date of Birth",
        labelStyle: TextStyle(color: Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.deepOrange, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        )),

        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              initialDate: currentValue ?? _currentDate.subtract(Duration(days: 365*18)),
              lastDate: _currentDate.subtract(Duration(days: 365*18)));
        },
      ),
    ]);
  }

}
