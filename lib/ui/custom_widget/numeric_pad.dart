import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';

class NumericPad extends StatelessWidget {

  final Function(int) onNumberSelected;
  final Function() checkValidOtpLength;

  NumericPad({@required this.onNumberSelected, this.checkValidOtpLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top:12.0, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildNumber(1,context),
                  buildNumber(2, context),
                  buildNumber(3,context),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildNumber(4, context),
                  buildNumber(5, context),
                  buildNumber(6, context),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildNumber(7, context),
                  buildNumber(8, context),
                  buildNumber(9, context),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildEmptySpace(),
                  buildNumber(0, context),
                  buildBackspace(context),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildNumber(int number, context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(number);
          checkValidOtpLength();
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackspace(context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onNumberSelected(-1);
          checkValidOtpLength();
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.backspace,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptySpace() {
    return Expanded(
      child: Container(),
    );
  }

}