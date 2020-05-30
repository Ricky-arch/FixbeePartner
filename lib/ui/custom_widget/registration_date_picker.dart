import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class RegistrationDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool) onDateEntered;

  const RegistrationDatePicker({Key key, this.controller, this.onDateEntered});
  @override
  _RegistrationDatePickerState createState() => _RegistrationDatePickerState();
}

class _RegistrationDatePickerState extends State<RegistrationDatePicker> {
  final format = DateFormat("dd-MM-yyyy");
  DateTime _currentDate= DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[

      Container(
        padding: EdgeInsets.all(8),
        height: 50,
        child: DateTimeField(

          controller: widget.controller,
          validator: (value) {
            if (value.toIso8601String().isEmpty) {
              return 'Please Enter Your Date of Birth';
            }
            return null;
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(.8)),
              hintText: "Date of Birth"),

          format: format,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1950),
                initialDate: currentValue ?? _currentDate.subtract(Duration(days: 365*18)),
                lastDate: _currentDate.subtract(Duration(days: 365*18)));
          },
        ),
      ),
    ]);
  }
}
