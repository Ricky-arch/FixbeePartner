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
    return Column(children: <Widget>[
      DateTimeField(
        controller: widget.controller,
        validator: (value) {
          if (value.toIso8601String().isEmpty) {
            return 'Please Enter Your Date of Birth';
          }
          return null;
        },
        style: TextStyle(
            color: PrimaryColors.backgroundColor, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          errorStyle: TextStyle(
              color: PrimaryColors.whiteColor,
              fontWeight: FontWeight.bold),
          errorText: "Your age must be above 18 years",
          fillColor: Colors.white,
          filled: true,
          labelText: "Date of Birth*",
          labelStyle:
              TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
//        enabledBorder: OutlineInputBorder(
//          borderSide: const BorderSide(
//              color: Colors.black, width: 2.0),
//          borderRadius: BorderRadius.circular(15.0),
//        )
        ),
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                        primary: PrimaryColors.backgroundColor),
                    focusColor: Colors.yellow,
                    backgroundColor: Colors.yellow,
                    buttonTheme: ButtonThemeData(buttonColor: Colors.black),
                  ),
                  child: child,
                );
              },
              context: context,
              firstDate: DateTime(1950),
              initialDate: currentValue ??
                  _currentDate.subtract(Duration(days: 365 * 18)),
              lastDate: _currentDate.subtract(Duration(days: 365 * 18)));
        },
      ),
    ]);
  }
}

class CustomTheme extends Theme {
  static int _fullAlpha = 255;
  static Color blueDark = new Color.fromARGB(_fullAlpha, 51, 92, 129);
  static Color blueLight = new Color.fromARGB(_fullAlpha, 116, 179, 206);
  static Color yellow = new Color.fromARGB(_fullAlpha, 252, 163, 17);
  static Color red = new Color.fromARGB(_fullAlpha, 255, 85, 84);
  static Color green = new Color.fromARGB(_fullAlpha, 59, 178, 115);

  static Color activeIconColor = yellow;

  CustomTheme(Widget child)
      : super(
            child: child,
            data: new ThemeData(
                primaryColor: blueDark,
                accentColor: yellow,
                cardColor: blueLight,
                backgroundColor: blueDark,
                highlightColor: red,
                splashColor: green));
}
