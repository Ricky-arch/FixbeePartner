import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/blocs/registration_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/registration_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/registration_model.dart';
import 'package:fixbee_partner/ui/custom_widget/date_picker.dart';
import 'package:fixbee_partner/ui/screens/login.dart';
import 'package:fixbee_partner/ui/screens/otp_for_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

import '../../Constants.dart';

Bee addBee;

class Registration extends StatefulWidget {
  final String phoneNumber;

  const Registration({Key key, this.phoneNumber}) : super(key: key);
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  RegistrationBloc _bloc;

  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  TextEditingController _phoneNumberController;
  final alternatePhoneNumber = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final pinCode = TextEditingController();
  final dateOfBirth = TextEditingController();
  final districtController = TextEditingController();
  final genderController = TextEditingController();
  final bankAccountNumber = TextEditingController();
  final ifscCode = TextEditingController();
  final accountHoldersName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = RegistrationBloc(RegistrationModel());
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
//    _getMessage();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _bloc?.extinguish();
    _phoneNumberController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  List<String> gender = ["Male", "Female", "Others"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _bloc.widget(
        onViewModelUpdated: (ctx, viewModel) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration:
                            BoxDecoration(color: PrimaryColors.backgroundColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'You look like a new Bee!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow,
                                            fontSize: 18)),
                                  ],
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.yellow,
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              (viewModel.loading)
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.yellow,
                    )
                  : SizedBox(),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  autovalidate: _validate,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: firstName,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please Enter Your First Name';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "First Name",
                              labelStyle: TextStyle(color: Colors.black54),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepOrange, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: middleName,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              if (!isAlpha(value))
                                return 'Please Enter Valid Middle name';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "Middle Name",
                              labelStyle: TextStyle(color: Colors.black54),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepOrange, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: lastName,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              if (!isAlpha(value))
                                return 'Please Enter Valid Last name';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "Last Name",
                              labelStyle: TextStyle(color: Colors.black54),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepOrange, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          enabled: false,
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (!isNumeric(value.trim())) {
                              return 'Please Enter Valid Phone Number';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "Phone Number",
                              labelStyle: TextStyle(color: Colors.black54),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepOrange, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: DatePicker(
                          controller: dateOfBirth,
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 60, right: 60),
                child: new Container(
                  width: 50,
                  height: 45.0,
                  child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _bloc.fire(RegistrationEvents.registrationFieldSet,
                              message: {
                                'firstname': firstName.text,
                                'middlename': middleName.text,
                                'lastname': lastName.text,
                                'phonenumber': _phoneNumberController.text,
                                'dateofbirth': dateOfBirth.text
                              }, onHandled: (e, m) {
                            if (m.registered) {
                              _bloc.fire(RegistrationEvents.requestOtp,
                                  message: {
                                    'phonenumber': _phoneNumberController.text
                                  }, onHandled: (e, m) {
                                if (m.sent) {
                                  goToOtpLoginScreen(ctx);
                                } else {
                                  Scaffold.of(ctx).showSnackBar(SnackBar(
                                    content: Text('Registration failed'),
                                  ));
                                }
                              });
                            } else {
                              Scaffold.of(ctx).showSnackBar(SnackBar(
                                content: Text('Registration failed'),
                              ));
                            }
                          });
                        }
                      },
                      child: Text("Next"),
                      textColor: Colors.white,
                      color: PrimaryColors.backgroundColor,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ),
              ),
            ],
          );
        },
      )),
    );
  }

  void goToOtpLoginScreen(BuildContext ctx) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpForLogin(
                  phoneNumber: _phoneNumberController.text,
                )));
  }
}
