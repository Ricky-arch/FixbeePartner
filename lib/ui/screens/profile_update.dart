import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/custom_widget/fixbee_textfield.dart';
import 'package:flutter/material.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColors.yellowColor,
      body: SafeArea(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 100,),
            FixbeeTextField(
              label: 'First name',
              icon: Icons.person,
              editable: true,
              initialText: "Saurav",
              notSet: false,
              color: PrimaryColors.backgroundColor,
              submit: (value)async{
                await Future.delayed(Duration(seconds: 2));
              },
            ),
          ],
        ),
      ),
    );
  }
}
