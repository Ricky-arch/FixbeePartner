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
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(child: _bloc.widget(
        onViewModelUpdated: (ctx, viewModel) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Theme.of(context).canvasColor,
                    child: Form(
                        key: _formKey,
                        autovalidate: _validate,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: SvgPicture.asset(
                                            "assets/logo/bee_outline.svg",
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Oh! A new Bee?\n",
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        TextSpan(
                                          text: "Fill in to continue...",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                cursorColor: Theme.of(context).accentColor,
                                controller: firstName,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please Enter Your First Name';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).cardColor,
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "First Name*",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: middleName,
                                cursorColor: Theme.of(context).accentColor,
                                validator: (value) {
                                  if (value.trim().isNotEmpty) {
                                    if (!isAlpha(value))
                                      return 'Please Enter Valid Middle name';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  fillColor: Theme.of(context).cardColor,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Middle Name",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                cursorColor: Theme.of(context).accentColor,
                                controller: lastName,
                                validator: (value) {
                                  if (value.trim().isNotEmpty) {
                                    if (!isAlpha(value))
                                      return 'Please Enter Valid Last name';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  fillColor: Theme.of(context).cardColor,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Last Name",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                cursorColor: Theme.of(context).accentColor,
                                controller: emailController,
                                validator: (value) {
                                  if (value
                                      .isNotEmpty) if (!isEmail(value.trim())) {
                                    return 'Please Enter a valid Email';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  fillColor: Theme.of(context).cardColor,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Email Address",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                cursorColor: Theme.of(context).accentColor,
                                enabled: false,
                                controller: _phoneNumberController,
                                validator: (value) {
                                  if (!isNumeric(value.trim())) {
                                    return 'Please Enter Valid Phone Number';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).cardColor,
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Phone Number*",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                cursorColor: Theme.of(context).accentColor,
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
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  fillColor: Theme.of(context).cardColor,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontWeight: FontWeight.bold),
                                  labelText:
                                      "Password (must be atleast 6 characters)*",
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    color: _obscureText
                                        ? Theme.of(context).hintColor
                                        : Colors.red,
                                    onPressed: () {
                                      _toggle();
                                    },
                                  ),
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField<String>(
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                                itemHeight: 50,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  fillColor: Theme.of(context).cardColor,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Gender*",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                items: gender.map((String gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      gender,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "By tapping next I agree to Fixbee: \n".toUpperCase(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launched = _launchInWebViewWithJavaScript(
                                "${EndPoints.TNC}");
                          },
                          child: Text(
                            'Terms and Conditions \u2197   ',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).errorColor),
                          ),
                        ),
                        Text(
                          '&   ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).errorColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launched = _launchInWebViewWithJavaScript(
                                "${EndPoints.PRIVACY_POLICY}");
                          },
                          child: Text(
                            'Privacy Policy \u2197   ',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).errorColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    (viewModel.loading)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 10, bottom: 10),
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).canvasColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).accentColor),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 60, right: 60),
                            child: new Container(
                              height: 35.0,
                              width: 110,
                              child: RaisedButton(
                                  elevation: 3,
                                  disabledColor: Theme.of(context).hintColor,
                                  disabledTextColor: Theme.of(context).accentColor,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      print("Valid");
                                      _bloc.fire(
                                        RegistrationEvents.registration,
                                        message: {
                                          'firstName': firstName.text,
                                          'middleName': middleName.text,
                                          'lastName': lastName.text,
                                          'phone': _phoneNumberController.text,
                                          'dateOfBirth': dateOfBirth.text,
                                          'email': emailController.text,
                                          'password': passwordController.text,
                                          'gender': gender[_selectedGender],
                                        },
                                        onHandled: (e, m) {
                                          if (m.registered) {
                                            _bloc.fire(
                                                RegistrationEvents.requestOtp,
                                                message: {
                                                  'phonenumber':
                                                      _phoneNumberController
                                                          .text
                                                }, onHandled: (e, m) {
                                              if (m.sent) {
                                                goToOtpLoginScreen(ctx);
                                              } else {
                                                Scaffold.of(ctx)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(m.error
                                                      .substring(
                                                          15,
                                                          m.error
                                                              .toString()
                                                              .length)
                                                      .toUpperCase()),
                                                ));
                                              }
                                            });
                                          } else {
                                            Scaffold.of(ctx)
                                                .showSnackBar(SnackBar(
                                              content: Text(m.error
                                                  .substring(15,
                                                      m.error.toString().length)
                                                  .toUpperCase()),
                                            ));
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: Text("Next"),
                                  textColor:Theme.of(context).canvasColor,
                                  color: Theme.of(context).primaryColor,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ),
                          ),
                    SizedBox(height: 20,),
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
