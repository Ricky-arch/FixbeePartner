import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/otp_login_bloc.dart';
import 'package:fixbee_partner/events/otp_events.dart';
import 'package:fixbee_partner/models/otp_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/otp_field.dart';
import 'package:fixbee_partner/ui/custom_widget/otp_insert.dart';
import 'package:fixbee_partner/ui/screens/all_service_selection_screen.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OtpForLogin extends StatefulWidget {
  final String phoneNumber;

  const OtpForLogin({@required this.phoneNumber});
  @override
  _OtpForLoginState createState() => _OtpForLoginState();
}

class _OtpForLoginState extends State<OtpForLogin> {
  OTPController _otpController = OTPController();
  TextEditingController _otpInsertController = TextEditingController();
  OtpLoginBloc _bloc;
  Box _BEENAME;
  _openHive() async {
    _BEENAME = Hive.box<String>("BEE");
  }

  @override
  void initState() {
    _openHive();
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
              return Wrap(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Enter OTP sent to the number:\n",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: PrimaryColors.backgroundColor),
                                ),
                                TextSpan(
                                  text: (widget.phoneNumber == null)
                                      ? "+91-1234567890"
                                      : "+91-${widget.phoneNumber}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        OTPInsert(
                          controller: _otpInsertController,
                          onOTPOfInvalidLength: () {
                            _bloc
                                .pushViewModel(viewModel..enableButton = false);
                          },
                          onOTPOfValidLength: (otp) {
                            _bloc.pushViewModel(viewModel..enableButton = true);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Didn't receive the OTP?   ",
                                  style: TextStyle(
                                      color: PrimaryColors.backgroundColor)),
                            ])),
                            SizedBox(
                              width: 5,
                            ),
                            (viewModel.resendingOtp)
                                ? CircularProgressIndicator()
                                : RaisedButton(
                                    elevation: 2,
                                    color: PrimaryColors.backgroundColor,
                                    onPressed: () {
                                      _bloc.fire(
                                        OtpEvents.resendOtp,
                                        message: {'phone': widget.phoneNumber},
                                      );
                                      _otpInsertController.clear();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Resend Code",
                                        style: TextStyle(
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        (viewModel.verifying || viewModel.fetchingAllBeeConfiguration)
                            ? CustomCircularProgressIndicator()
                            : RaisedButton(
                                elevation: 3,
                                disabledColor: Colors.grey,
                                color: Colors.yellow,
                                onPressed: viewModel.enableButton
                                    ? () {
                                        _bloc.fire(
                                          OtpEvents.onOtpVerify,
                                          message: {
                                            'phone': widget.phoneNumber,
                                            'otp': _otpInsertController.text
                                          },
                                          onHandled: (e, m) {
                                            if (m.valid) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              _bloc.fire(
                                                  OtpEvents.fetchSaveBeeDetails,
                                                  onHandled: (e, m) {
                                                if (!m.serviceSelected) {
                                                  goToJobSelectionScreen(ctx);
                                                } else {
                                                  if(m.bee.dpUrl!=null)_BEENAME.put("dpUrl", m.bee.dpUrl);
                                                  print(m.bee.myRating.toString()+'UI OTP');
                                                  _BEENAME.put('myRating', m.bee.myRating.toString());
                                                  _BEENAME.put('myWallet', m.bee.walletAmount.toString());
                                                  goToNavigationScreen(ctx);
                                                }
                                              });
                                            } else {
                                              _otpInsertController.clear();
                                              _showOnOtpInvalid();
                                            }
                                            //  }F
                                          },
                                        );
                                      }
                                    : null,
                                child: Text("VERIFY AND PROCEED"),
                              ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  )
                ],
              );
           // }
          }),
        ),
      ),
    );
  }

  void goToJobSelectionScreen(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => AllServiceSelection()));
  }

  void goToRegistrationScreen(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Registration()));
  }

  void goToNavigationScreen(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NavigationScreen()));
  }

  _showOnOtpInvalid() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("OTP invalid or expired!"),
            actions: [
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
