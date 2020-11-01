import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/custom_widget/active_order_remainder.dart';
import 'package:fixbee_partner/ui/custom_widget/new_service_notification.dart';
import 'package:fixbee_partner/ui/custom_widget/work_animation.dart';
import 'package:fixbee_partner/ui/screens/customize_service.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:fixbee_partner/ui/screens/past_order_billing_screen.dart';

import 'package:fixbee_partner/ui/screens/dummy_screen.dart';
import 'package:fixbee_partner/ui/screens/login.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: PrimaryColors.backgroundColor, // status bar color
  ));

  runApp(
    MaterialApp(
      theme: ThemeData(
        // accentColor: Colors.redAccent,
        //canvasColor: Color(0x2551771),
        //brightness: Brightness.dark,
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
//        backgroundColor: Color(0x2551771),
          body: SplashScreen()),
    ),
  );
}
