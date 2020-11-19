import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_rating_widget.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class DummyScreen extends StatefulWidget {
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          RaisedButton(
            child: Text("Tap"),
            onPressed: () {
              _showPaymentSuccessDialog();
            },
          )
        ]));
  }

  _showPaymentSuccessDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: CustomRatingWidget(),
          );
        });
  }
}
