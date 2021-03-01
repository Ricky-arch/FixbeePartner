import 'dart:ui';

import 'package:fixbee_partner/blocs/update_profile_bloc.dart';
import 'package:fixbee_partner/events/update_profile_event.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/update_profile_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/registration_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:string_validator/string_validator.dart';

import '../../Constants.dart';
import '../../data_store.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  UpdateProfileBloc _bloc;

  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController alternatePhoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController genderController = TextEditingController();
  DateTime dt;
  Box _BEENAME;
  _openHive() {
    _BEENAME = Hive.box<String>("BEE");
  }

  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  @override
  void initState() {
    _openHive();
    super.initState();
    _bloc = UpdateProfileBloc(UpdateProfileModel());
    // _bloc.fire(UpdateProfileEvent.fetchProfile, onHandled: (e, m) {
    //   firstName = TextEditingController(text: m.firstName);
    //   middleName = TextEditingController(text: m.middleName ?? "");
    //   lastName = TextEditingController(text: m.lastName ?? "");
    //   phoneNumber = TextEditingController(text: m.phoneNumber);
    //   alternatePhoneNumber =
    //       TextEditingController(text: m.alternatePhoneNumber ?? "");
    //   email = TextEditingController(text: m.emailAddress ?? "");
    //   address1 = TextEditingController(text: m.address1 ?? "");
    //   address2 = TextEditingController(text: m.address2);
    //   pinCode = TextEditingController(text: m.pinCode);
    //   genderController = TextEditingController(text: m.gender);
    //   dateOfBirth = TextEditingController(text: m.dob);
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.extinguish();
    firstName.dispose();
    middleName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    alternatePhoneNumber.dispose();
    email.dispose();
    address1.dispose();
    address2.dispose();
    pinCode.dispose();
    dateOfBirth.dispose();
    genderController.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  List<String> gender = ["Male", "Female", "Others"];
  int _selectedGender = 0;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: PrimaryColors.backgroundcolorlight,
        appBar: AppBar(
          backgroundColor: PrimaryColors.backgroundColor,
          automaticallyImplyLeading: false,
          title: Stack(
            children: <Widget>[
              Container(
                  decoration:
                      BoxDecoration(color: PrimaryColors.backgroundColor),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SvgPicture.asset(
                                "assets/logo/bee_outline.svg",
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'ADD CHANGES TO YOUR PERSONAL',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        body: SafeArea(
          child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
            if ((viewModel.loading)) {
              return Center(
                child: Container(
                    height: 50,
                    width: 50,
                    child: CustomCircularProgressIndicator()),
              );
            } else {
              return ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
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
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Please Enter Your First Name';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                labelText: "First Name",
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
                                    color: Colors.red,
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
                                if (value.trim().isEmpty) {
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
                                    color: Colors.red,
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
                              controller: alternatePhoneNumber,
                              validator: (value) {
                                if (value.trim().isNotEmpty) {
                                  if (!isNumeric(value.trim()))
                                    return 'Please Enter Valid Alternate Phone Number';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                labelText: "Alternate Phone Number",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value.trim().isNotEmpty) {
                                  if (!isEmail(value.trim()))
                                    return 'Please Enter Valid Email Number';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(
                                    color: Colors.red,
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
                              controller: address1,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Please Enter Your Address';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                labelText: "Address",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: pinCode,
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  if (!isNumeric(value.trim())) {
                                    return 'Please Enter Valid Pincode';
                                  }
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6)
                              ],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                labelText: "Pincode",
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: RegistrationDatePicker(
                              controller: dateOfBirth,
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
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                labelText: "Gender",
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
                                        fontWeight: FontWeight.bold),
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
                            padding: const EdgeInsets.only(
                                left: 30.0, top: 20, right: 30, bottom: 30),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.black,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _bloc.fire(
                                            UpdateProfileEvent.updateProfile,
                                            message: {
                                              'firstName': firstName.text,
                                              'middleName':
                                                  middleName.text ?? "",
                                              'lastName': lastName.text ?? "",
                                              'alternatePhoneNumber':
                                                  alternatePhoneNumber.text,
                                              'email': email.text,
                                              'address': address1.text,
                                              'pin-code': pinCode.text,
                                              'dateOfBirth': dateOfBirth.text,
                                              'gender': gender[_selectedGender],
                                            }, onHandled: (e, m) {
                                          _BEENAME.put(
                                              "myName",
                                              getMyName(
                                                  firstName.text,
                                                  middleName.text ?? '',
                                                  lastName.text ?? ''));
                                          Bee bee = Bee()
                                            ..firstName = firstName.text
                                            ..middleName = middleName.text ?? ''
                                            ..lastName = lastName.text ?? ''
                                            ..emailAddress = email.text
                                            ..address = address1.text
                                            ..pinCode = pinCode.text
                                            ..gender = gender[_selectedGender];
                                          DataStore.me = bee;
                                          Navigator.pop<String>(context,
                                              'CHANGED TO PERSONAL ADDED SUCCESSFULLY!');
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        "CONFIRM",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    onPressed: () {
                                      print(
                                          DataStore.me.phoneNumber.toString() +
                                              "XXX");
                                      print(
                                          DataStore.me.emailAddress.toString() +
                                              "YYY");
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        'DECLINE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  void onGenderSelected(int indexOf) {
    setState(() {
      _selectedGender = indexOf;
    });
  }
}
