import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInsert extends StatefulWidget {
  final Function(String otp) onOTPOfValidLength;
  final Function onOTPOfInvalidLength;
  final TextEditingController controller;

  const OTPInsert(
      {this.onOTPOfValidLength, this.onOTPOfInvalidLength, this.controller});

  @override
  _OTPInsertState createState() => _OTPInsertState();
}

class _OTPInsertState extends State<OTPInsert> {
  var focusNode = FocusNode();

  var dig1 = "";
  var dig2 = "";
  var dig3 = "";
  var dig4 = "";
  var dig5 = "";
  var dig6 = "";

  int inFocus = 0;
  int lastFocus = 0;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OTPDigit(
                digit: dig1,
                onFocus: inFocus == 0,
              ),
              OTPDigit(
                digit: dig2,
                onFocus: inFocus == 1,
              ),
              OTPDigit(
                digit: dig3,
                onFocus: inFocus == 2,
              ),
              OTPDigit(
                digit: dig4,
                onFocus: inFocus == 3,
              ),
              OTPDigit(
                digit: dig5,
                onFocus: inFocus == 4,
              ),
              OTPDigit(
                digit: dig6,
                onFocus: inFocus == 5,
              ),
            ],
          ),
        ),
        Container(
            height: 20,
            width: (32 * 6.0) + 8 + 8 + 8,
            child: TextField(
              controller: widget.controller,
              autofocus: true,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              showCursor: false,
              enableInteractiveSelection: false,
              decoration: InputDecoration(border: InputBorder.none),
              style: TextStyle(color: Colors.transparent),
              focusNode: focusNode,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              onChanged: (text) {
                print(text);
                setState(() {
                  if (text.length == 0) {
                    dig1 = "";
                    dig2 = "";
                    dig3 = "";
                    dig4 = "";
                    dig5 = "";
                    dig6 = "";
                    inFocus = 0;
                    widget.onOTPOfInvalidLength();
                  }
                  if (text.length == 1) {
                    dig1 = text[0];
                    dig2 = "";
                    dig3 = "";
                    dig4 = "";
                    dig5 = "";
                    dig6 = "";
                    inFocus = 0;
                    widget.onOTPOfInvalidLength();
                  }
                  if (text.length == 2) {
                    dig1 = text[0];
                    dig2 = text[1];
                    dig3 = "";
                    dig4 = "";
                    dig5 = "";
                    dig6 = "";
                    inFocus = 1;
                    widget.onOTPOfInvalidLength();
                  }
                  if (text.length == 3) {
                    dig1 = text[0];
                    dig2 = text[1];
                    dig3 = text[2];
                    dig4 = "";
                    dig5 = "";
                    dig6 = "";
                    inFocus = 2;
                    widget.onOTPOfInvalidLength();
                  }
                  if (text.length == 4) {
                    dig1 = text[0];
                    dig2 = text[1];
                    dig3 = text[2];
                    dig4 = text[3];
                    dig5 = "";
                    dig6 = "";
                    inFocus = 3;
                    widget.onOTPOfInvalidLength();
                  }
                  if (text.length == 5) {
                    dig1 = text[0];
                    dig2 = text[1];
                    dig3 = text[2];
                    dig4 = text[3];
                    dig5 = text[4];
                    dig6 = "";
                    inFocus = 4;
                    widget.onOTPOfInvalidLength();
                  }
                  if (text.length == 6) {
                    dig1 = text[0];
                    dig2 = text[1];
                    dig3 = text[2];
                    dig4 = text[3];
                    dig5 = text[4];
                    dig6 = text[5];
                    inFocus = 5;
                    widget.onOTPOfValidLength(text);
                  }
                });
              },
            )),
      ],
    );
  }
}

class OTPDigit extends StatelessWidget {
  final String digit;
  final bool onFocus;

  const OTPDigit({this.digit, this.onFocus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 32,
        width: 32,
        child: Column(
          children: <Widget>[
            Text(
              digit,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColors.backgroundColor),
            ),
            SizedBox(
              height: 4,
            ),
            AnimatedContainer(
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: onFocus
                    ? PrimaryColors.backgroundColor
                    : Colors.grey.withOpacity(0.3),
              ),
              width: onFocus ? 21 : 12,
              height: onFocus ? 4 : 3,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
