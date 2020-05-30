import 'package:fixbee_partner/blocs/otp_login_bloc.dart';
import 'package:fixbee_partner/events/otp_events.dart';
import 'package:fixbee_partner/models/otp_model.dart';
import 'package:fixbee_partner/ui/custom_widget/otp_field.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:flutter/material.dart';

class OtpForLogin extends StatefulWidget {
  final String phoneNumber;

  const OtpForLogin({@required this.phoneNumber});
  @override
  _OtpForLoginState createState() => _OtpForLoginState();
}

class _OtpForLoginState extends State<OtpForLogin> {
  OTPController _otpController = OTPController();
  OtpLoginBloc _bloc;

  @override
  void initState() {
    _bloc = OtpLoginBloc(OtpModel());
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x2551771),
      body: Center(
        child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          if (viewModel.verifying) {
            return CircularProgressIndicator();
          } else {
            return Column(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OTPField(
                    otpController: _otpController,
                    onOTPEntered: (lengthIsValid) {
                      _bloc.pushViewModel(
                          viewModel..enableButton = lengthIsValid);
                      print("${_otpController.getInputOTP()}");
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
                        style: TextStyle(
                          color: Color(0xfff39c12),
                        ),
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
                  onPressed: viewModel.enableButton
                      ? () {
                          _bloc.fire(
                            OtpEvents.onOtpVerify,
                            message: {
                              'phone': widget.phoneNumber,
                              'otp': _otpController.getInputOTP()
                            },
                            onHandled: (e, m) {
                              if (!m.exist) {
                                goToRegistrationScreen(ctx);
                              } else {
                                if (m.valid) {
                                  goToHomeScreen(ctx);
                                } else {
                                  Scaffold.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text('OTP invalid or expired.'),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        }
                      : null,
                  child: Text("VERIFY AND PROCEED"),
                )
              ],
            );
          }
        }),
      ),
    );
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NavigationScreen()));
  }

  void goToRegistrationScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Registration()));
  }
}
