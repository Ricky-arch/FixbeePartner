import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Constants.dart';

class ProfileTextFieldF extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function upDate;
  final LengthLimitingTextInputFormatter lft;
  final labelText;
  final bool editable;

  const ProfileTextFieldF({
    Key key,
    this.controller,
    this.labelText,
    this.editable,
    this.upDate,
    this.textInputType,
    this.lft,
  }) : super(key: key);
  @override
  _ProfileTextFieldFState createState() => _ProfileTextFieldFState();
}

class _ProfileTextFieldFState extends State<ProfileTextFieldF> {
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: PrimaryColors.backgroundColor,
            border: Border.all(color: Colors.orange)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 8),
                child: TextField(
                  keyboardType: widget.textInputType,
                  inputFormatters: (widget.lft != null) ? [widget.lft] : [],
                  focusNode: focusNode,
                  autofocus: widget.editable,
                  controller: widget.controller,
                  style: TextStyle(
                      color: PrimaryColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  cursorColor: PrimaryColors.yellowColor,
                  enabled: enabled,
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
                ),
              ),
            ),
            (widget.editable)
                ? Flexible(
                    flex: 4,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (buttonTitle == 'CONFIRM') {
                            widget.upDate(widget.controller.text);
                          }
                          if (widget.editable) {
                            if (enabled == false) {
                              enabled = true;
                              buttonTitle = 'CONFIRM';
                            } else {
                              enabled = false;
                              buttonTitle = 'EDIT';
                            }
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 8, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              buttonTitle,
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
