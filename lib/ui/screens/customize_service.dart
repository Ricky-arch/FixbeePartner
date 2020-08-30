import 'package:flutter/material.dart';

import '../../Constants.dart';
class CustomizeService extends StatefulWidget {
  @override
  _CustomizeServiceState createState() => _CustomizeServiceState();
}

class _CustomizeServiceState extends State<CustomizeService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColors.backgroundColor,
        automaticallyImplyLeading: false,
        //backgroundColor: Data.backgroundColor,
        title: Stack(
          children: <Widget>[
            Container(
                decoration:
                BoxDecoration(color: PrimaryColors.backgroundColor),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'PROFILE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15)),
                    ],
                  ),
                ))
          ],
        ),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
