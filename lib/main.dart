import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    // navigation bar color
//    statusBarColor: Colors.transparent, // status bar color
//  ));

  runApp(
    MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
//        backgroundColor: Color(0x2551771),
            body: SplashScreen()),
        ),
  );
}
