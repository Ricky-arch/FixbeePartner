import 'package:fixbee_partner/blocs/registration_bloc.dart';
import 'package:fixbee_partner/events/registration_events.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/registration_model.dart';
import 'package:fixbee_partner/ui/custom_widget/date_picker.dart';
import 'package:fixbee_partner/ui/screens/otp_for_login.dart';
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
  bool isEnabledButton = false;

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
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  color: PrimaryColors.backgroundColor,
                  child: Form(
                      key: _formKey,
                      autovalidate: _validate,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
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
                          (viewModel.loading)
                              ? Padding(
                                  padding: const EdgeInsets.all(20.0),
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
                                labelText: "First Name",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
//                                      enabledBorder: OutlineInputBorder(
//                                        borderSide: const BorderSide(
//                                            color: Colors.black, width: 2.0),
//                                        borderRadius: BorderRadius.circular(15.0),
//                                      )
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
//                                      enabledBorder: OutlineInputBorder(
//                                        borderSide: const BorderSide(
//                                            color: Colors.black, width: 2.0),
//                                        borderRadius: BorderRadius.circular(15.0),
//                                      )
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
//                                      enabledBorder: OutlineInputBorder(
//                                        borderSide: const BorderSide(
//                                            color: Colors.black, width: 2.0),
//                                        borderRadius: BorderRadius.circular(15.0),
//                                      )
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
                                errorStyle: TextStyle(color: Colors.black),
                                labelText: "Phone Number",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
//                                      enabledBorder: OutlineInputBorder(
//                                        borderSide: const BorderSide(
//                                            color: Colors.black, width: 2.0),
//                                        borderRadius: BorderRadius.circular(15.0),
//                                      )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: DatePicker(
                              controller: dateOfBirth,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 2 - 120,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "TERMS AND CONDITIONS",
                        style: TextStyle(
                            color: PrimaryColors.backgroundColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: GestureDetector(
                          onTap: () {
                            _launched = _launchInWebViewWithJavaScript("${EndPoints.TNC}");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.orangeAccent.withOpacity(.9),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            width: MediaQuery.of(context).size.width / 5,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "READ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I ACCEPT",
                        style: TextStyle(
                            color: PrimaryColors.backgroundColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        activeColor: Colors.red,
                        activeTrackColor: Colors.black,
                        inactiveThumbColor: Colors.green,
                        inactiveTrackColor: Colors.black.withOpacity(.5),

                        onChanged: (value) {
                          setState(() {
                            isEnabledButton = value;
                          });
                        },
                        value: isEnabledButton,
                      ),
                    ],
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
                          onPressed: isEnabledButton
                              ? () {
                                  if (_formKey.currentState.validate()) {
                                    _bloc.fire(
                                        RegistrationEvents.registrationFieldSet,
                                        message: {
                                          'firstname': firstName.text,
                                          'middlename': middleName.text,
                                          'lastname': lastName.text,
                                          'phonenumber':
                                              _phoneNumberController.text,
                                          'dateofbirth': dateOfBirth.text
                                        }, onHandled: (e, m) {
                                      if (m.registered) {
                                        _bloc.fire(
                                            RegistrationEvents.requestOtp,
                                            message: {
                                              'phonenumber':
                                                  _phoneNumberController.text
                                            }, onHandled: (e, m) {
                                          if (m.sent) {
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
                                        Scaffold.of(ctx).showSnackBar(SnackBar(
                                          content: Text('Registration failed'),
                                        ));
                                      }
                                    },);
                                  }
                                }
                              : null,
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

class WaveClipperTwo extends CustomClipper<Path> {
  bool reverse;
  bool flip;

  WaveClipperTwo({this.reverse = false, this.flip = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse && !flip) {
      path.lineTo(0.0, size.height - 20);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
          Offset(size.width - (size.width / 3.25), size.height - 65);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (!reverse && flip) {
      path.lineTo(0.0, size.height - 40);
      var firstControlPoint = Offset(size.width / 3.25, size.height - 65);
      var firstEndPoint = Offset(size.width / 1.75, size.height - 20);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, size.height);
      var secondEP = Offset(size.width, size.height - 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height - 20);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (reverse && flip) {
      path.lineTo(0.0, 20);
      var firstControlPoint = Offset(size.width / 3.25, 65);
      var firstEndPoint = Offset(size.width / 1.75, 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, 0);
      var secondEP = Offset(size.width, 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
