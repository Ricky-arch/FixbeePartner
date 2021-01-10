import 'package:fixbee_partner/blocs/otp_login_bloc.dart';
import 'package:fixbee_partner/events/otp_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/otp_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/numeric_pad.dart';
import 'package:fixbee_partner/ui/screens/all_service_selection_screen.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
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
  OtpLoginBloc _bloc;
  String code = "";
  Box _BEENAME;
  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
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
    _bloc = OtpLoginBloc(OtpModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        if (viewModel.verifying)
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Spacer(),
                  CustomCircularProgressIndicator(),
                  Spacer(),
                ],
              ),
            ],
          );
        else
          return Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    "Enter 6- digit OTP sent to the number:\n",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: PrimaryColors.backgroundColor),
                              ),
                              TextSpan(
                                text: "+91-8787300192",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                              color: PrimaryColors.backgroundColor,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (viewModel.resendingOtp)
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
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              ),
              Column(
                children: [
                  (viewModel.verifying)
                      ? Row(
                          children: [
                            Spacer(),
                            CustomCircularProgressIndicator(),
                            Spacer(),
                          ],
                        )
                      : Container(
                          height: 50,
                          width: 180,
                          child: RaisedButton(
                            elevation: 3,
                            disabledTextColor: Colors.white,
                            disabledColor: Colors.grey,
                            color: Colors.yellow,
                            child: Text(
                              "VERIFY AND PROCEED",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
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

                                          _bloc.fire(
                                              OtpEvents.fetchSaveBeeDetails,
                                              onHandled: (e, m) {
                                            _bloc.fire(OtpEvents.getFcmToken,
                                                onHandled: (e, m) {
                                              _bloc.fire(
                                                  OtpEvents
                                                      .checkForServiceSelected,
                                                  onHandled: (e, m) async{
                                                 await refreshAllData(m.bee);
                                                if (!m.serviceSelected) {
                                                  goToJobSelectionScreen(ctx);
                                                } else {
                                                  goToNavigationScreen(ctx);
                                                }
                                              });
                                            });
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
                ],
              ),
              SizedBox(
                height: 20,
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
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
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
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
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

  Future<void> refreshAllData(Bee bee) async{
    print(bee.id);
    _BEENAME.put("ID", bee.id);
    _BEENAME.put(
        ("myName"), getMyName(bee.firstName, bee.middleName, bee.lastName));
    _BEENAME.put("myDocumentVerification", (bee.verified) ? "true" : "false");
    _BEENAME.put("dpUrl", bee.dpUrl);
    _BEENAME.put("myActiveStatus", (bee.active) ? "true" : "false");
    _BEENAME.put("myWallet", bee.walletAmount.toString());
  }
}
