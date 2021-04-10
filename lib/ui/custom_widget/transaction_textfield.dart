import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Constants.dart';

class TransactionTextfield extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function upDate;
  final LengthLimitingTextInputFormatter lft;
  final labelText;
  final bool editable;

  const TransactionTextfield({
    Key key,
    this.controller,
    this.labelText,
    this.editable,
    this.upDate,
    this.textInputType,
    this.lft,
  }) : super(key: key);
  @override
  _TransactionTextfieldState createState() => _TransactionTextfieldState();
}

class _TransactionTextfieldState extends State<TransactionTextfield> {
  FocusNode focusNode;
  bool enabled = false;
  String buttonTitle = 'EDIT';
  @override
  void initState() {
    focusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: PrimaryColors.backgroundColor,
          border: Border.all(color: Colors.orange),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 8),
          child: TextField(
            onChanged: (val) {
              widget.upDate(widget.controller.text);
            },
            keyboardType: widget.textInputType,
            enabled: true,
            cursorColor: PrimaryColors.yellowColor,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.only(top: 1),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: Colors.orange,
                fontSize: 14,
              ),
            ),
            controller: widget.controller,
            style: TextStyle(
                color: PrimaryColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
