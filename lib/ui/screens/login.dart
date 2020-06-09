import 'package:fixbee_partner/blocs/login_bloc.dart';
import 'package:fixbee_partner/events/login_events.dart';

import 'package:fixbee_partner/models/login_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bloc_widget.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Constants.dart';
import 'otp_for_login.dart';

TextEditingController textEditingController;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isButtonEnabled = false;
  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    _bloc = LoginBloc(LoginModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PrimaryColors.backgroundColor,
        body: SafeArea(
          child: BlocWidget<LoginEvents, LoginModel>(
            bloc: _bloc,
            onViewModelUpdated: (ctx, viewModel) {
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                            top: 80,
                          ),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Hello! bee,\n",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow),
                                ),
                                TextSpan(
                                  text: "sign in to continue",
                                  style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(75.0),
                              )),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 45.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: new Container(),
                                      flex: 1,
                                    ),
                                    Flexible(
                                      child: new TextFormField(
                                        //decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))),
                                        textAlign: TextAlign.center,
                                        autofocus: false,
                                        enabled: false,
                                        initialValue: "+91",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xff1d1b27)),
                                      ),
                                      flex: 3,
                                    ),
                                    Flexible(
                                      child: new Container(),
                                      flex: 1,
                                    ),
                                    Flexible(
                                      child: new TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please enter your number";
                                          }
                                          return null;
                                        },
                                        onChanged: isPhoneNumberValid,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10)
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "Enter Your Phone No.",
                                          hintStyle: TextStyle(
                                              fontSize: 18.5,
                                              color: Colors.teal[500]),
                                        ),
                                        controller: textEditingController,
                                        textAlign: TextAlign.start,
                                        autofocus: false,
                                        enabled: true,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xff1d1b27)),
                                      ),
                                      flex: 8,
                                    ),
                                    Flexible(
                                      child: new Container(),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 50.0,
                                  ),
                                  child: new Container(
                                    width: 150.0,
                                    height: 35.0,
                                    child: new RaisedButton(
                                        disabledColor: Colors.teal[100],
                                        disabledTextColor: Colors.white,
                                        onPressed: isButtonEnabled
                                            ? () {
                                                _bloc.fire(LoginEvents.onLogIn,
                                                    message: {
                                                      'phone':
                                                          textEditingController
                                                              .text
                                                    }, onHandled: (e, m) {
                                                  if (m.exist) {
                                                    goToOtpScreen(context);
                                                  } else {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (ctx) {
                                                      return Registration();
                                                    }));
                                                  }
                                                });
                                              }
                                            : null,
                                        child: Text("Get OTP"),
                                        textColor: PrimaryColors.backgroundColor,
                                        color: Colors.yellow,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0))),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: GestureDetector(
                                      child: Text(
                                        "Don't have an Account?",
                                        style: TextStyle(
                                            color: Color(0xff1d1b27),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (ctx) {
                                          return Registration();
                                        }));
                                      }),
                                ),
                              )
                            ],
                          )),
                    ],
                  )
                ],
              );
            },
          ),
        ));
  }

  void isPhoneNumberValid(String value) {
    setState(() {
      if (textEditingController.text.trim().length == 10) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }

  void goToOtpScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpForLogin(
                  phoneNumber: textEditingController.text,
                )));
  }

  void goToRegisterScreen(BuildContext context) {}
}
