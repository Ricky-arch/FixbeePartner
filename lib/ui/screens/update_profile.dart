import 'dart:ui';

import 'package:fixbee_partner/blocs/update_profile_bloc.dart';
import 'package:fixbee_partner/events/update_profile_event.dart';
import 'package:fixbee_partner/models/update_profile_model.dart';
import 'package:fixbee_partner/ui/custom_widget/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

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

  @override
  void initState() {
    super.initState();
    _bloc = UpdateProfileBloc(UpdateProfileModel());
    _bloc.fire(UpdateProfileEvent.fetchProfile, onHandled: (e, m) {
      firstName = TextEditingController(text: m.firstName);
      middleName = TextEditingController(text: m.middleName);
      lastName = TextEditingController(text: m.lastName);
      phoneNumber = TextEditingController(text: m.phoneNumber);
      alternatePhoneNumber =
          TextEditingController(text: m.alternatePhoneNumber);
      email = TextEditingController(text: m.emailAddress);
      address1 = TextEditingController(text: m.address1);
      address2 = TextEditingController(text: m.address2);
      pinCode = TextEditingController(text: m.pinCode);
      genderController = TextEditingController(text: m.gender);
      dateOfBirth = TextEditingController(text: m.dob);
    });
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
    return Scaffold(
      body: SafeArea(
        child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                height: 60,
                color: Color.fromRGBO(3, 9, 23, 1),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                          size: 25,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 20),
                      Center(
                          child: Text(
                        "Update Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
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
                            if (value.trim().isEmpty) {
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
                          controller: alternatePhoneNumber,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              if (!isNumeric(value.trim()))
                                return 'Please Enter Valid Alternate Phone Number';
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
                              labelText: "Alternate Phone Number",
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
                          controller: email,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              if (!isEmail(value.trim()))
                                return 'Please Enter Valid Email Number';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "Email Address",
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
                          controller: address1,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please Enter Your Address';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "Address",
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
                          controller: pinCode,
                          validator: (value) {
                            if (value.isNotEmpty) {
                              if (!isNumeric(value.trim())) {
                                return 'Please Enter Valid Pincode';
                              }
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6)
                          ],
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "Pincode",
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: DropdownButtonFormField<String>(
                          itemHeight: 50,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              labelText: "Gender",
                              labelStyle: TextStyle(color: Colors.black54),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepOrange, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                          items: gender.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String genderSelected) {
                            if (genderSelected != null) {
                              onGenderSelected(gender.indexOf(genderSelected));
                            }
                          },
                          value: gender[_selectedGender],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 20, right: 10, bottom: 30),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.green,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _bloc.fire(UpdateProfileEvent.updateProfile,
                                        message: {
                                          'firstName': firstName.text,
                                          'middleName': middleName.text,
                                          'lastName': lastName.text,
                                          'alternatePhoneNumber':
                                              alternatePhoneNumber.text,
                                          'email': email.text,
                                          'address': address1.text,
                                          'pin-code': pinCode.text,
                                          'dateOfBirth': dateOfBirth.text,
                                          'gender': gender[_selectedGender],
                                        }, onHandled: (e, m) {
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    "CONFIRM",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: OutlineButton(
                                highlightedBorderColor: Colors.red,
                                textColor: Colors.red,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'DECLINE',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
        }),
      ),
    );
  }

  void onGenderSelected(int indexOf) {
    setState(() {
      _selectedGender = indexOf;
    });
  }
}
