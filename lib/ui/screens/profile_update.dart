import 'dart:developer';

import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/update_profile_bloc.dart';
import 'package:fixbee_partner/events/update_profile_event.dart';
import 'package:fixbee_partner/models/update_profile_model.dart';
import 'package:fixbee_partner/ui/custom_widget/fixbee_textfield.dart';
import 'package:fixbee_partner/ui/custom_widget/profile_textfield.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:string_validator/string_validator.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTimeFormatter dtf = DateTimeFormatter();
  TextEditingController _firstNameController,
      _middleNameController,
      _lastNameController,
      _phoneNumber,
      _altPhoneNumber,
      _email,
      _gender,
      _dateOfBirth;
  UpdateProfileBloc _bloc;
  Box _BEENAME;
  _openHive() {
    _BEENAME = Hive.box<String>("BEE");
  }

  @override
  void initState() {
    _bloc = UpdateProfileBloc(UpdateProfileModel());
    _openHive();
    _bloc.fire(UpdateProfileEvent.fetchProfile, onHandled: (e, m) {
      _firstNameController = TextEditingController(text: m.firstName);
      _middleNameController = TextEditingController(text: m.middleName);
      _lastNameController = TextEditingController(text: m.lastName);
      _email = TextEditingController(text: m.emailAddress);
      _phoneNumber = TextEditingController(text: m.phoneNumber);
      _altPhoneNumber = TextEditingController(text: m.alternatePhoneNumber);
      _gender = TextEditingController(text: m.gender);
      _dateOfBirth = TextEditingController(text: dtf.getDate(m.dob.toString()));
    });

    super.initState();
  }

  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 12, 12, 0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Add changes to your  ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          TextSpan(
                            text:
                            "Profile",
                            style: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  (viewModel.loading)
                      ? LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: PrimaryColors.backgroundColor,
                        )
                      : Column(
                          children: [
                            ProfileTextFieldF(
                              controller: _firstNameController,
                              textInputType: TextInputType.text,
                              labelText: "First Name",
                              editable: true,
                              upDate: (value) {
                                String query = '''
                            mutation{
                                update(input:{
                                  name:{
                                    firstName:"$value"
                                    middleName:"${_BEENAME.get('middleName') ?? ''}"
                                    lastName:"${_BEENAME.get('lastName') ?? ''}"
                                  }
                                }){
                                  name{
                                    firstName
                                  }
                                }
                              }
                            ''';
                                _bloc.fire(UpdateProfileEvent.updateEachField,
                                    message: {'query': query},
                                    onHandled: (e, m) {
                                  if (m.updated) {
                                    showInSnackBar(
                                        'First Name Updated Successfully');
                                    _BEENAME.put('firstName', value);
                                    _BEENAME.put(
                                        'myName',
                                        getMyName(
                                            value,
                                            _BEENAME.get('middleName') ?? '',
                                            _BEENAME.get('lastName') ?? ''));
                                  } else {
                                    showInSnackBar('Error Updating First Name');
                                  }
                                });
                              },
                            ),
                            ProfileTextFieldF(
                              controller: _middleNameController,
                              textInputType: TextInputType.text,
                              labelText: "Middle Name",
                              editable: true,
                              upDate: (value) {
                                String query = '''
                            mutation{
                                update(input:{
                                  name:{
                                    firstName:"${_BEENAME.get('firstName') ?? ''}"
                                    middleName:"$value"
                                    lastName:"${_BEENAME.get('lastName') ?? ''}"
                                  }
                                }){
                                  name{
                                    middleName
                                  }
                                }
                              }
                            ''';
                                _bloc.fire(UpdateProfileEvent.updateEachField,
                                    message: {'query': query},
                                    onHandled: (e, m) {
                                  if (m.updated) {
                                    showInSnackBar(
                                        'Middle Name Updated Successfully');
                                    _BEENAME.put('middleName', value);
                                    _BEENAME.put(
                                        'myName',
                                        getMyName(
                                            _BEENAME.get('firstName'),
                                            value ?? '',
                                            _BEENAME.get('lastName') ?? ''));
                                  } else {
                                    showInSnackBar(
                                        'Error Updating Middle Name');
                                  }
                                });
                              },
                            ),
                            ProfileTextFieldF(
                              controller: _lastNameController,
                              textInputType: TextInputType.text,
                              labelText: "Last Name",
                              editable: true,
                              upDate: (value) {
                                String query = '''
                            mutation{
                                update(input:{
                                  name:{
                                    firstName:"${_BEENAME.get('firstName') ?? ''}"
                                    middleName:"${_BEENAME.get('middleName') ?? ''}"
                                    lastName:"$value"
                                  }
                                }){
                                  name{
                                    lastName
                                  }
                                }
                              }
                            ''';
                                _bloc.fire(UpdateProfileEvent.updateEachField,
                                    message: {'query': query},
                                    onHandled: (e, m) {
                                  if (m.updated) {
                                    showInSnackBar(
                                        'Last Name Updated Successfully');
                                    _BEENAME.put('lastName', value);
                                    _BEENAME.put(
                                        'myName',
                                        getMyName(
                                            _BEENAME.get('firstName'),
                                            _BEENAME.get('middleName') ?? '',
                                            value ?? ''));
                                  } else {
                                    showInSnackBar('Error Updating Last Name');
                                  }
                                });
                              },
                            ),
                            ProfileTextFieldF(
                              controller: _email,
                              textInputType: TextInputType.emailAddress,
                              labelText: "Email",
                              editable: (_email.text.toString().isNotEmpty)
                                  ? false
                                  : true,
                              upDate: (value) {},
                            ),
                            ProfileTextFieldF(
                              controller: _phoneNumber,
                              textInputType: TextInputType.numberWithOptions(
                                  decimal: false),
                              lft: LengthLimitingTextInputFormatter(10),
                              labelText: "Phone Number",
                              editable: false,
                            ),
                            ProfileTextFieldF(
                              controller: _altPhoneNumber,
                              textInputType: TextInputType.numberWithOptions(
                                  decimal: false),
                              lft: LengthLimitingTextInputFormatter(10),
                              labelText: 'Alt Phone Number',
                              editable: true,
                              upDate: (value) {
                                if (value.length < 10 || !isNumeric(value)) {
                                  log('invalid', name: 'alternatePhoneNumber');
                                  showInSnackBar('Invalid Phone Number');
                                } else {
                                  String query = '''
                              mutation{
                                  update(input:{
                                    altPhone:"$value"
                                  }){
                                    altPhone
                                  }
                                }
                              ''';
                                  _bloc.fire(UpdateProfileEvent.updateEachField,
                                      message: {'query': query},
                                      onHandled: (e, m) {
                                    if (m.updated) {
                                      showInSnackBar(
                                          'Alternate Phone Number Updated');
                                    } else {
                                      showInSnackBar(
                                          'Error Updating Alternate Phone Number');
                                    }
                                  });
                                }
                              },
                            ),
                            ProfileTextFieldF(
                              controller: _gender,
                              labelText: "Gender",
                              editable: false,
                            ),
                            ProfileTextFieldF(
                              controller: _dateOfBirth,
                              labelText: "Date of Birth",
                              editable: false,
                            ),
                          ],
                        ),
                ],
              ),
            );
          })),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: PrimaryColors.backgroundColor,
        content: new Text(
          value,
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        )));
  }
}
