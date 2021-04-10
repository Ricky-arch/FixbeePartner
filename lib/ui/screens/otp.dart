import 'package:fixbee_partner/blocs/otp_login_bloc.dart';
import 'package:fixbee_partner/events/otp_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/otp_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/numeric_pad.dart';
import 'package:fixbee_partner/ui/screens/all_service_selection_screen.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Constants.dart';
import 'navigation_screen.dart';

class OTP extends StatefulWidget {
  final String phoneNumber;

  const OTP({Key key, this.phoneNumber}) : super(key: key);
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool _isButtonEnabled;
  bool _showRequestAgainButton;
  OtpLoginBloc _bloc;
  String code = "";
  Box _BEENAME;
  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  _triggerRequestAgainTimer() async {
    await Future.delayed(const Duration(seconds: 120), () {
      setState(() {
        _showRequestAgainButton = true;
      });
    });
  }

  _openHive() async {
    await Hive.openBox<String>("BEE");
    _BEENAME = Hive.box<String>("BEE");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openHive();
    _isButtonEnabled = false;

    _showRequestAgainButton = false;
    _triggerRequestAgainTimer();
    _bloc = OtpLoginBloc(OtpModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Enter OTP\n\n",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: "sent to ${widget.phoneNumber}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildCodeNumberBox(
                              code.length > 0 ? code.substring(0, 1) : ""),
                          buildCodeNumberBox(
                              code.length > 1 ? code.substring(1, 2) : ""),
                          buildCodeNumberBox(
                              code.length > 2 ? code.substring(2, 3) : ""),
                          buildCodeNumberBox(
                              code.length > 3 ? code.substring(3, 4) : ""),
                          buildCodeNumberBox(
                              code.length > 4 ? code.substring(4, 5) : ""),
                          buildCodeNumberBox(
                              code.length > 5 ? code.substring(5, 6) : ""),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Didn't receive code? ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        (_showRequestAgainButton)
                            ? (viewModel.resendingOtp)
                                ? Container(
                                    child: CustomCircularProgressIndicator(),
                                    height: 30,
                                    width: 30,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      _bloc.fire(
                                        OtpEvents.resendOtp,
                                        message: {'phone': widget.phoneNumber},
                                      );
                                      setState(() {
                                        code = "";
                                        _isButtonEnabled = false;
                                      });
                                    },
                                    child: Text(
                                      "Request again",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Column(
              children: [
                (viewModel.verifying || viewModel.fetchingAllBeeConfiguration)
                    ? Row(
                        children: [
                          Spacer(),
                          CustomCircularProgressIndicator(),
                          Spacer(),
                        ],
                      )
                    : Row(
                        children: [
                          Spacer(),
                          Container(
                            height: 35,
                            width: 150,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              elevation: 3,
                              disabledTextColor: Theme.of(context).accentColor,
                              disabledColor: Theme.of(context).hintColor,
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "VERIFY",
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              onPressed: _isButtonEnabled
                                  ? () {
                                      _bloc.fire(
                                        OtpEvents.onOtpVerify,
                                        message: {
                                          'phone': widget.phoneNumber,
                                          'otp': code
                                        },
                                        onHandled: (e, m) {
                                          if (m.valid) {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            Scaffold.of(ctx)
                                                .showSnackBar(SnackBar(
                                              content: Text('Otp registered'),
                                            ));
                                            _bloc.fire(
                                                OtpEvents.fetchSaveBeeDetails,
                                                onHandled: (e, m) async {
                                              if (m.walletError) {
                                                _showMessageDialog(
                                                    m.walletError);
                                              } else {
                                                await refreshAllData(m.bee);
                                                if (!m.serviceSelected) {
                                                  goToJobSelectionScreen(ctx);
                                                } else {
                                                  goToNavigationScreen(ctx);
                                                }
                                              }
                                            });
                                          } else {
                                            _showOnOtpInvalid();
                                          }
                                          //  }
                                        },
                                      );
                                    }
                                  : null,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            NumericPad(
              checkValidOtpLength: () {
                setState(() {
                  if (code.length < 6)
                    _isButtonEnabled = false;
                  else if (code.length == 6) _isButtonEnabled = true;
                });
              },
              onNumberSelected: (value) {
                print(value);
                setState(() {
                  if (value != -1) {
                    if (code.length < 6) {
                      code = code + value.toString();
                    }
                  } else if (code.length != 0) {
                    code = code.substring(0, code.length - 1);
                  }
                  print(code);
                });
              },
            ),
          ],
        );
      })),
    );
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 8,
        height: MediaQuery.of(context).size.width / 8,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(.5),
                  blurRadius: 10.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ),
    );
  }

  void goToJobSelectionScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AllServiceSelection()),
        (Route<dynamic> route) => false);
  }

  void goToRegistrationScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Registration()),
        (Route<dynamic> route) => false);
  }

  void goToNavigationScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => NavigationScreen()),
        (Route<dynamic> route) => false);
  }

  _showOnOtpInvalid() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "OTP invalid or expired!",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            actions: [
              RaisedButton(
                color: Theme.of(context).cardColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Close",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          );
        });
  }

  _showMessageDialog(message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: PrimaryColors.backgroundColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          );
        });
  }

  Future<void> refreshAllData(Bee bee) async {
    print(bee.firstName);
    _BEENAME.put("myPhone", bee.phoneNumber);
    _BEENAME.put(
        ("myName"), getMyName(bee.firstName, bee.middleName, bee.lastName));
    _BEENAME.put("myDocumentVerification", (bee.verified) ? "true" : "false");
    _BEENAME.put("dpUrl", bee.dpUrl);
    _BEENAME.put("myActiveStatus", (bee.active) ? "true" : "false");
    _BEENAME.put("myWallet", bee.walletAmount.toString());
    _BEENAME.put("myRating", bee.myRating.toString());
  }
}
