import 'dart:async';

import 'package:fixbee_partner/ui/custom_widget/numeric_pad.dart';
import 'package:fixbee_partner/ui/screens/otp.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';
class Dummy extends StatefulWidget {
  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("Tap"),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OTP(
                          phoneNumber: "8787300192",
                        )));
              },
            )
          ],
      ),
    );
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width/8,
        height: MediaQuery.of(context).size.width/8,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75)
              )
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // var oneSec = const Duration(seconds:1);
  // Timer timer;
  // int value=0;
  // bool switchValue=true;
  // @override
  // void initState() {
  //   if(switchValue){
  //     startTimer();
  //   }
  //   super.initState();
  // }
  // @override
  // Widget build(BuildContext context) {
  //
  //   return Scaffold(
  //
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //
  //       children: [
  //
  //         NumericPad()
  //         // Center(child: Text(value.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
  //         // Center(
  //         //   child: Switch(
  //         //     value: switchValue,
  //         //     onChanged: (value){
  //         //       setState(() {
  //         //         switchValue=value;
  //         //       });
  //         //       if(value){
  //         //         _showPaymentSuccessDialog();
  //         //         startTimer();
  //         //       }
  //         //       if(!value){
  //         //         endTimer();
  //         //       }
  //         //     },
  //         //   ),
  //         // ),
  //       ],
  //
  //     ),
  //   );
  // }
  // _showPaymentSuccessDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.transparent,
  //           elevation: 0,
  //           content: Container(
  //             height: 250,
  //             width: 250,
  //             child: FlareActor(
  //               "assets/animations/cms_remix.flr",
  //               alignment: Alignment.center,
  //               fit: BoxFit.contain,
  //               animation: "Untitled",
  //             ),
  //           ),
  //         );
  //       });
  // }
  // startTimer(){
  //   timer= Timer.periodic(oneSec, (Timer t) {
  //
  //     setState(() {
  //       value++;
  //     });
  //
  //   });
  // }
  // endTimer(){
  //   timer.cancel();
  // }
}
