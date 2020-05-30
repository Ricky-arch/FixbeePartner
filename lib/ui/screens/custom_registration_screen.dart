import 'package:fixbee_partner/animations/faded_animations.dart';
import 'package:fixbee_partner/blocs/registration_bloc.dart';
import 'package:fixbee_partner/events/registration_events.dart';
import 'package:fixbee_partner/models/registration_model.dart';
import 'package:fixbee_partner/ui/custom_widget/registration_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

import 'otp_for_login.dart';

class CustomRegistrationScreen extends StatefulWidget {
  @override
  _CustomRegistrationScreenState createState() =>
      _CustomRegistrationScreenState();
}

class _CustomRegistrationScreenState extends State<CustomRegistrationScreen> {
  bool _phoneValid = false, _firstNameValid = false, _dateOfBirthValid = false;
  RegistrationBloc _bloc;

  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final dateOfBirth = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = RegistrationBloc(RegistrationModel());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.extinguish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: SafeArea(
        child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                    FadeAnimation(
                        1.2,
                        Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: FadeAnimation(
                          1.5,
                          Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: Colors.grey[300],
                                  ))),
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    keyboardType: TextInputType.number,
                                    onChanged: isPhoneNumberValid,
                                    controller: phoneNumber,
                                    validator: (value) {
                                      if (!isNumeric(value.trim())) {
                                        return 'Please Enter Valid Phone Number';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.grey.withOpacity(.8)),
                                        hintText: "Enter Phone number"),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 7,
                                  color: Color.fromRGBO(3, 9, 23, 1),
                                ),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[300]))),
                                  child: TextFormField(
                                    onChanged: isFirstNameValid,
                                    controller: firstName,
                                    validator: (value) {
                                      if (value.trim().isNotEmpty) {
                                        if (!isAlpha(value))
                                          return 'Please Enter First Last name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.grey.withOpacity(.8)),
                                        hintText: "First Name"),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 7,
                                  color: Color.fromRGBO(3, 9, 23, 1),
                                ),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[300]))),
                                  child: TextFormField(
                                    controller: middleName,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.grey.withOpacity(.8)),
                                        hintText: "Middle Name"),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 7,
                                  color: Color.fromRGBO(3, 9, 23, 1),
                                ),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[300]))),
                                  child: TextFormField(
                                    controller: lastName,
                                    validator: (value) {
                                      if (value.trim().isNotEmpty) {
                                        if (!isAlpha(value))
                                          return 'Please Enter Valid Last name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.grey.withOpacity(.8)),
                                        hintText: "Last Name"),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 7,
                                  color: Color.fromRGBO(3, 9, 23, 1),
                                ),
                                RegistrationDatePicker(
                                  controller: dateOfBirth,
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                        1.8,
                        Center(
                          child: Container(
                            width: 140,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(15),
                            child: RaisedButton(
                              disabledColor: Colors.grey,
                              color: Colors.white,
                              onPressed: (_phoneValid &&
                                      _firstNameValid &&
                                      _dateOfBirthValid)
                                  ? () {
                                      _bloc.fire(
                                          RegistrationEvents
                                              .registrationFieldSet,
                                          message: {
                                            'firstname': firstName.text,
                                            'middlename': middleName.text,
                                            'lastname': lastName.text,
                                            'phonenumber': phoneNumber.text,
                                            'dateofbirth': dateOfBirth.text
                                          }, onHandled: (e, m) {
                                        if (m.registered) {
                                          _bloc.fire(
                                              RegistrationEvents.requestOtp,
                                              message: {
                                                'phonenumber': phoneNumber.text
                                              }, onHandled: (e, m) {
                                            if (m.sent) {
                                              print("Hello World");
                                              goToOtpLoginScreen(ctx);
                                            } else {
                                              Scaffold.of(ctx)
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text('Registration failed'),
                                              ));
                                            }
                                          });
                                        } else {
                                          Scaffold.of(ctx)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Registration failed'),
                                          ));
                                        }
                                      });
                                    }
                                  : null,
                              child: Center(
                                  child: Text(
                                "Confirm",
                                style: TextStyle(color: Colors.black),
                              )),
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void isPhoneNumberValid(String value) {
    setState(() {
      if (value.toString().trim().length == 10 && isNumeric(value.toString())) {
        _phoneValid = true;
      } else {
        _phoneValid = false;
      }
    });
  }

  void isFirstNameValid(String value) {
    setState(() {
      if (value.isEmpty && isAlpha(value))
        _firstNameValid = false;
      else
        _firstNameValid = true;
    });
  }

  void isDateOfBirthValid(String value) {
    setState(() {
      if (value.isEmpty)
        _dateOfBirthValid = false;
      else
        _dateOfBirthValid = true;
    });
  }

  void goToOtpLoginScreen(BuildContext ctx) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpForLogin(
                  phoneNumber: phoneNumber.text,
                )));
  }
}
