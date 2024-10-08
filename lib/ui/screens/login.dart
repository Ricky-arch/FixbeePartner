import 'package:fixbee_partner/blocs/login_bloc.dart';
import 'package:fixbee_partner/events/login_events.dart';
import 'package:fixbee_partner/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fixbee_partner/models/login_model.dart';
import 'package:fixbee_partner/ui/custom_widget/bloc_widget.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:fixbee_partner/ui/screens/otp.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
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
  double width;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();

    _bloc = LoginBloc(LoginModel());
  }

  @override
  void dispose() {
    // textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocWidget<LoginEvents, LoginModel>(
      bloc: _bloc,
      onViewModelUpdated: (ctx, viewModel) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40.0, 10, 0, 20),
                        child: Container(
                            height: MediaQuery.of(context).size.width / 6,
                            width: MediaQuery.of(context).size.width / 6,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  "assets/logo/bee_outline.svg",
                                  height: 65,
                                ))),
                      ),
                      Spacer()
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 40,
                      ),
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Hello! bee,\n",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                TextSpan(
                                  text:
                                      "Sign in your phone number to continue...",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      // border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(75.0),

                      )),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: new Container(),
                            flex: 1,
                          ),
                          Flexible(
                            child: new TextFormField(
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(.5),
                                    width: 3),
                              )),
                              textAlign: TextAlign.center,
                              autofocus: false,
                              enabled: false,
                              initialValue: "+91",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Theme.of(context).accentColor),
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
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                hintText: "Enter Your Phone No.",
                                hintStyle: TextStyle(
                                    fontSize: 18.5,
                                    color: Theme.of(context).hintColor),
                              ),
                              controller: textEditingController,
                              textAlign: TextAlign.start,
                              cursorColor: Theme.of(context).accentColor,
                              autofocus: false,
                              enabled: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false),
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            flex: 8,
                          ),
                          Flexible(
                            child: new Container(),
                            flex: 1,
                          ),
                        ],
                      ),
                      (viewModel.loading)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).accentColor),
                                backgroundColor: Theme.of(context).canvasColor,
                              ),
                            )
                          : InkWell(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              20,
                                    ),
                                    Container(
                                      width: 150.0,
                                      height: 35.0,
                                      child: new RaisedButton(
                                          elevation: 3,
                                          disabledColor:
                                              Theme.of(context).hintColor,
                                          disabledTextColor:
                                              Theme.of(context).accentColor,
                                          onPressed: isButtonEnabled
                                              ? () {
                                                  _bloc.fire(
                                                      LoginEvents.onLogIn,
                                                      message: {
                                                        'phone':
                                                            textEditingController
                                                                .text
                                                      }, onHandled: (e, m) {
                                                    if (m.exist) {
                                                      goToOtpScreen(
                                                          context, m.exist);
                                                    } else {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) {
                                                        return Registration(
                                                          phoneNumber:
                                                              textEditingController
                                                                  .text,
                                                        );
                                                      }));
                                                    }
                                                  });
                                                }
                                              : null,
                                          child: Text(
                                            "NEXT",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          textColor:
                                              Theme.of(context).canvasColor,
                                          color: Theme.of(context).primaryColor,
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  )),
            ),
          ],
        );
      },
    ));
  }

  void isPhoneNumberValid(String value) {
    setState(() {
      if (isNumeric(textEditingController.text.trim()) &&
          textEditingController.text.trim().length == 10) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }

  void goToOtpScreen(BuildContext context, bool exist) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTP(
                  phoneNumber: textEditingController.text,
                )));
  }
}
