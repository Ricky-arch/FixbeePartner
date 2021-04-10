import 'package:fixbee_partner/utils/colors.dart';
import 'package:fixbee_partner/utils/themes.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class CustomDatePicker extends StatefulWidget {
  final Function setDate;
  final DateTime startDate;
  final title;
  const CustomDatePicker({Key key, this.setDate, this.startDate, this.title})
      : super(key: key);
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();
  DateTime limitDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
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
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: limitDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        widget.setDate(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.date_range,
                          size: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 4),
                        child: Text(
                          "${selectedDate.toString()}".split(' ')[0],
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
