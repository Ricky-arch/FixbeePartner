

import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/custom_widget/active_order_remainder.dart';
import 'package:fixbee_partner/ui/custom_widget/new_service_notification.dart';
import 'package:fixbee_partner/ui/custom_widget/work_animation.dart';

import 'package:fixbee_partner/ui/screens/dummy_screen.dart';
import 'package:fixbee_partner/ui/screens/login.dart';
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
        primaryColor: Colors.yellow,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
//        backgroundColor: Color(0x2551771),
        body:
            //OtpForLogin(phoneNumber: "8787300192R",),
            //Registration()
            //HistoryScreen()
           // WalletScreen()
            //OtpForLogin(),
            //ServiceSelectionScreen()
            //BankDetails()
            //NavigationScreen()
            //Home()
            //JobNotification() //DatePicker()
            //ImagePicker()//MapScreen()
            //NotificationHandler()
            //WorkScreen()
            //CustomRegistrationScreen()
            //UpdateProfile()
            //WorkScreen()
            //NavigationScreen()
            //ProfileNew(),
        //JobNotification()
       // CustomProfile()
       //AvailableAccounts()
        //WorkAnimation()
        //HistoryScreen()
        SplashScreen()
        //Login()
        //ActiveOrderRemainder(),
        //DummyScreen()
       // NewServiceNotification(),
        //DialogBox()
        //DialogShow()
        //NewServiceNotification(),
        //TestLocation()
        //VerificationDocuments()
        //ServiceSelectionScreen()
        //padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        //padding: EdgeInsets.all(20),
//           Login(
//            districtModel: DistrictModel(Repository.instance),
//          ),
      ),
    ),
  );
}
