import 'package:flutter/material.dart';

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
              color: Colors.yellow[600],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
//                      Container(
//                        height: 50,
//                        width: 50,
//                        decoration: BoxDecoration(
//                            image: DecorationImage(
//                                image: AssetImage(
//                                    'assets/custom_icons/value.svg'), fit: BoxFit.cover)),
//                      ),
                    Icon(Icons.event),
                    SizedBox(width: MediaQuery.of(context).size.width / 20),
                    Center(
                        child: Text(
                          "History",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
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
