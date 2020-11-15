import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/screens/history_screen.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: PrimaryColors.backgroundColor,
    statusBarBrightness: Brightness.light
  ));

  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body:
          SplashScreen()
      ),
    ),
  );
}
