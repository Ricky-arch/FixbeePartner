import 'package:fixbee_partner/blocs/registration_bloc.dart';
import 'package:fixbee_partner/events/registration_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/registration_model.dart';
import 'package:fixbee_partner/ui/custom_widget/date_picker.dart';
import 'package:fixbee_partner/ui/screens/login.dart';
import 'package:fixbee_partner/ui/screens/otp_for_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

Bee addBee;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  RegistrationBloc _bloc;

  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
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
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _bloc?.extinguish();
    firstName.dispose();
    middleName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    alternatePhoneNumber.dispose();
    email.dispose();
    address.dispose();
    pinCode.dispose();
    dateOfBirth.dispose();
    districtController.dispose();
    genderController.dispose();
    bankAccountNumber.dispose();
    ifscCode.dispose();
    accountHoldersName.dispose();
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
                height: 60,
                color: Colors.yellow[600],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_left,
                          color: Colors.black,
                          size: 25,
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 20),
                      Center(
                          child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
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
                          controller: phoneNumber,
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
                                'phonenumber': phoneNumber.text,
                                'dateofbirth': dateOfBirth.text
                              }, onHandled: (e, m) {
                            if (m.registered) {
                              _bloc.fire(RegistrationEvents.requestOtp,
                                  message: {'phonenumber': phoneNumber.text},
                                  onHandled: (e, m) {
                                if (m.sent) {
                                  print("Hello World");
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
                      color: Colors.red,
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
                  phoneNumber: phoneNumber.text,
                )));
  }
}
