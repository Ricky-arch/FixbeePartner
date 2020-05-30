import 'package:fixbee_partner/ui/custom_widget/otp_field.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
import 'package:flutter/material.dart';
OTPController otpController= OTPController();
bool enableButton = false;
class OtpForRegistration extends StatefulWidget {
  final String phoneNumber;

  const OtpForRegistration({@required this.phoneNumber});

  @override
  _OtpForRegistrationState createState() => _OtpForRegistrationState();
}

class _OtpForRegistrationState extends State<OtpForRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x2551771),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Enter the OTP sent to ",
                      style: TextStyle(color: Colors.white70)),
                  TextSpan(
                    text: "${widget.phoneNumber}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: OTPField(
                otpController: otpController,
                onOTPEntered: (lengthIsValid) {
                  setState(() {
                    enableButton = lengthIsValid;
                  });
                  print("${otpController.getInputOTP()}");
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(text: "Didn't receive the OTP?   "),
                    ])),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  child: Text(
                    "Resend Code",
                    style: TextStyle(color: Color(0xfff39c12),),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              disabledColor: Colors.grey,
              color: Colors.white,
              onPressed: enableButton
                  ? () {
                if (otpController
                    ?.getInputOTP()
                    ?.toString()
                    ?.trim()
                    ?.length ==
                    6) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceSelectionScreen()));
                }
              }
                  : null,
              child: Text("VERIFY AND PROCEED"),
            )
          ],
        ),
      ),
    );
  }
}
