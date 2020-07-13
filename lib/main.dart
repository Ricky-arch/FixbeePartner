import 'package:fixbee_partner/ui/screens/custom_profile.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
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
            //WalletScreen()
            //OtpForLogin(phoneNumber: "4545454545",)
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
        //CustomProfile()
       //AvailableAccounts()
        SplashScreen()
        //Profile()//ServiceSelectionScreen()
        //padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        //padding: EdgeInsets.all(20),
//           Login(
//            districtModel: DistrictModel(Repository.instance),
//          ),
      ),
    ),
  );
}
