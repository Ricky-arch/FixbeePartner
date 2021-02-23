import 'package:fixbee_partner/blocs/registration_bloc.dart';
import 'package:fixbee_partner/events/registration_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/registration_model.dart';
import 'package:fixbee_partner/ui/custom_widget/OvalBottomBorderClipper.dart';
import 'package:fixbee_partner/ui/custom_widget/date_picker.dart';
import 'package:fixbee_partner/ui/screens/otp.dart';
import 'package:fixbee_partner/ui/screens/otp_for_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Future<void> _launched;
  int _selectedGender = 0;

  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  TextEditingController _phoneNumberController;
  final alternatePhoneNumber = TextEditingController();
  final emailController = TextEditingController();
  final address = TextEditingController();
  final pinCode = TextEditingController();
  final dateOfBirth = TextEditingController();
  final districtController = TextEditingController();
  final genderController = TextEditingController();
  final bankAccountNumber = TextEditingController();
  final passwordController = TextEditingController();
  final ifscCode = TextEditingController();
  final accountHoldersName = TextEditingController();
  bool isEnabledButton = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _bloc = RegistrationBloc(RegistrationModel());
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
//    _getMessage();
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _bloc?.extinguish();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  List<String> gender = ["male", "female", "others"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _bloc.widget(
        onViewModelUpdated: (ctx, viewModel) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    width: double.infinity,
                    color: PrimaryColors.backgroundColor,
                    child: Form(
                        key: _formKey,
                        autovalidate: _validate,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height:20,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: SvgPicture.asset(
                                            "assets/logo/bee_outline.svg",
                                          ))),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Oh! A new Bee?\nFill in to continue...",
                                      style: TextStyle(
                                          color: PrimaryColors.yellowColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 80,
                            ),
                            (viewModel.loading)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: LinearProgressIndicator(
                                      minHeight: 3,
                                      backgroundColor:
                                          PrimaryColors.backgroundColor,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : SizedBox(),
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
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: PrimaryColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "First Name*",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
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
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: PrimaryColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Middle Name",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
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
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: PrimaryColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Last Name",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value
                                      .isNotEmpty) if (!isEmail(value.trim())) {
                                    return 'Please Enter a valid Email';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: PrimaryColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Email Address",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
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
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: PrimaryColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Phone Number*",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: _obscureText,
                                obscuringCharacter: "●",
                                validator: (value) {
                                  if (value.trim().length < 6) {
                                    return 'Password must be atleast 6 characters';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,

                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: PrimaryColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                  labelText:
                                      "Password (must be atleast 6 characters)*",
                                  suffixIcon:  Padding(
                                      padding:  EdgeInsets.only(top: 15.0),
                                      child:  IconButton(icon: Icon(Icons.remove_red_eye_outlined), color: _obscureText?Colors.grey:Colors.red, onPressed: (){
                                        _toggle();
                                      },)),
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField<String>(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                itemHeight: 50,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: PrimaryColors.whiteColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Gender*",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                items: gender.map((String gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      gender,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String genderSelected) {
                                  if (genderSelected != null) {
                                    onGenderSelected(
                                        gender.indexOf(genderSelected));
                                  }
                                },
                                value: gender[_selectedGender],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: DatePicker(
                                controller: dateOfBirth,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 7,
                            )
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                      child: Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 8, 8, 8),
                                    child: Text(
                                      "By tapping next I agree to Fixbee: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: PrimaryColors.backgroundColor),
                                    ),
                                  )),
                                  TextSpan(
                                      text: "\n· ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                  TextSpan(
                                      text: "Terms and Conditions ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _launched =
                                              _launchInWebViewWithJavaScript(
                                                  "${EndPoints.TNC}");
                                        }),
                                  TextSpan(
                                      text: "\n· ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                  TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _launched =
                                              _launchInWebViewWithJavaScript(
                                                  "${EndPoints.PRIVACY_POLICY}");
                                        }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 60, right: 60),
                      child: new Container(
                        height: 45.0,
                        width: 150,
                        child: RaisedButton(
                            elevation: 3,
                            disabledColor: Colors.teal[100],
                            disabledTextColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                print("Valid");
                                _bloc.fire(
                                  RegistrationEvents.registrationFieldSet,
                                  message: {
                                    'firstName': firstName.text,
                                    'middleName': middleName.text,
                                    'lastName': lastName.text,
                                    'phone': _phoneNumberController.text,
                                    'dateOfBirth': dateOfBirth.text,
                                    'email':emailController.text,
                                    'password':passwordController.text,
                                    'gender': gender[_selectedGender],
                                  },
                                  onHandled: (e, m) {
                                    if (m.registered) {
                                      _bloc.fire(RegistrationEvents.requestOtp,
                                          message: {
                                            'phonenumber':
                                                _phoneNumberController.text
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
                                  },
                                );
                              }
                            },
                            child: Text("NEXT"),
                            textColor: Colors.yellow,
                            color: PrimaryColors.backgroundColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      )),
    );
  }

  void onGenderSelected(int indexOf) {
    setState(() {
      _selectedGender = indexOf;
    });
  }

  void goToOtpLoginScreen(BuildContext ctx) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => OTP(
                  phoneNumber: _phoneNumberController.text,
                )));
  }
}
