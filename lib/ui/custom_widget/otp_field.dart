import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

FocusNode digit0 = FocusNode();
FocusNode digit1 = FocusNode();
FocusNode digit2 = FocusNode();
FocusNode digit3 = FocusNode();
FocusNode digit4 = FocusNode();
FocusNode digit5 = FocusNode();
TextEditingController controller0 = TextEditingController();
TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();
TextEditingController controller3 = TextEditingController();
TextEditingController controller4 = TextEditingController();
TextEditingController controller5 = TextEditingController();

int digitCount = 0;

class OTPField extends StatefulWidget {
  final Function(bool) onOTPEntered;
  final OTPController otpController;
  final Function onOTPLengthInvalid;

  const OTPField({
    this.onOTPEntered,
    this.otpController,
    this.onOTPLengthInvalid,
  });
  @override
  _OTPFieldState createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  @override
  void initState() {
    widget.otpController.getInputOTP = () {
      var dig0 = controller0.text;
      var dig1 = controller1.text;
      var dig2 = controller2.text;
      var dig3 = controller3.text;
      var dig4 = controller4.text;
      var dig5 = controller5.text;

      return "$dig0$dig1$dig2$dig3$dig4$dig5";
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width-75)/7,
            child: TextField(
              style: TextStyle(color: Colors.white),

              decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.white, width:  1.0),
                borderRadius: BorderRadius.circular(5.0),
              )),
              controller: controller0,
              onChanged: (num) {
                widget.onOTPEntered(otpLengthValid());
                if (num.length == 1) {
                  FocusScope.of(context).requestFocus(digit1);
                } else {
                  digitCount--;
                }
              },
              focusNode: digit0,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: (MediaQuery.of(context).size.width-75)/7,
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.white, width:  1.0),
                borderRadius: BorderRadius.circular(5.0),
              )),
              controller: controller1,
              onChanged: (num) {
                widget.onOTPEntered(otpLengthValid());
                if (num.length == 1) {
                  FocusScope.of(context).requestFocus(digit2);
                } else {
                  FocusScope.of(context).requestFocus(digit0);
                  digitCount--;
                }
              },
              focusNode: digit1,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: (MediaQuery.of(context).size.width-75)/7,
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.white, width:  1.0),
                borderRadius: BorderRadius.circular(5.0),
              )),
              controller: controller2,
              onChanged: (num) {
                widget.onOTPEntered(otpLengthValid());
                if (num.length == 1) {
                  FocusScope.of(context).requestFocus(digit3);
                } else {
                  FocusScope.of(context).requestFocus(digit1);
                  digitCount--;
                }
              },
              focusNode: digit2,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: (MediaQuery.of(context).size.width-75)/7,
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.white, width:  1.0),
                borderRadius: BorderRadius.circular(5.0),
              )),
              controller: controller3,
              onChanged: (num) {
                widget.onOTPEntered(otpLengthValid());
                if (num.length == 1) {
                  FocusScope.of(context).requestFocus(digit4);
                } else {
                  FocusScope.of(context).requestFocus(digit2);
                  digitCount--;
                }
              },
              focusNode: digit3,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: (MediaQuery.of(context).size.width-75)/7,
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.white, width:  1.0),
                borderRadius: BorderRadius.circular(5.0),
              )),
              controller: controller4,
              onChanged: (num) {
                widget.onOTPEntered(otpLengthValid());
                if (num.length == 1) {
                  FocusScope.of(context).requestFocus(digit5);
                } else {
                  FocusScope.of(context).requestFocus(digit3);
                  digitCount--;
                }
              },
              focusNode: digit4,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: (MediaQuery.of(context).size.width-75)/7,
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.white, width:  1.0),
                borderRadius: BorderRadius.circular(5.0),
              )),
              controller: controller5,
              onChanged: (num) {
                widget.onOTPEntered(otpLengthValid());
                if (num.length == 1) {

                } else {
                  FocusScope.of(context).requestFocus(digit4);
                  digitCount--;
                }
              },
              focusNode: digit5,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
            ),
          ),

        ],
      ),
    );
  }

  bool otpLengthValid() {
    return controller0.text.length == 1 &&
        controller2.text.length == 1 &&
        controller2.text.length == 1 &&
        controller3.text.length == 1 && controller4.text.length==1 && controller5.text.length==1;
  }
}

class OTPController {
  Function getInputOTP;
}
