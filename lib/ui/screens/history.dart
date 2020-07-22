import 'package:flutter/material.dart';

import '../../Constants.dart';
import '../../test.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen();
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60,
              color: PrimaryColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.event,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 40),
                    Center(
                        child: Text(
                      "History",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
