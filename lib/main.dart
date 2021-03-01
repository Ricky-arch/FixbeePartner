// @dart=2.9
import 'dart:io';

import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_date_picker.dart';
import 'package:fixbee_partner/ui/custom_widget/otp_digit_widget.dart';
import 'package:fixbee_partner/ui/custom_widget/transaction_type.dart';
import 'package:fixbee_partner/ui/screens/all_service_selection_screen.dart';
import 'package:fixbee_partner/ui/screens/dummy_screen.dart';
import 'package:fixbee_partner/ui/screens/login.dart';
import 'package:fixbee_partner/ui/screens/otp.dart';
import 'package:fixbee_partner/ui/screens/otp_for_login.dart';
import 'package:fixbee_partner/ui/screens/profile_update.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: PrimaryColors.backgroundColor,
    statusBarBrightness: Brightness.light
  ));

  WidgetsFlutterBinding.ensureInitialized();
  Directory document= await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(


          body:
          //OtpDigitWidget()
          //OtpForLogin()
        //OTP(phoneNumber: "+91-8787300192",)
          //SplashScreen()
        //Registration()
        //Login()
        //CustomDatePicker()
        //AllServiceSelection()
        //TransactionType()
        //ProfileUpdate()
        SplashScreen()
      ),
    ),
  );
}
