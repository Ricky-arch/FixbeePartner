import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen();
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final String price = "400.00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 60,
                  color: PrimaryColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/images/rupee.png"),
                          height: 35,
                          width: 25,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 40),
                        Center(
                            child: Text(
                              "Your Wallet",
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
                SizedBox(height: 10),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Current Balance :",
                          style: TextStyle(
                              color: PrimaryColors.backgroundColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: PrimaryColors.backgroundColor,
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Stack(children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 0, 40),
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                            color: PrimaryColors.backgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomLeft: Radius.circular(40))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 38, 8, 8),
                              child: Image(
                                image: AssetImage("assets/images/rupee.png"),
                                height: 35,
                                width: 25,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 30, 8, 8),
                              child: Text(
                                price,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: double.parse((price.length *
                                        (MediaQuery.of(context).size.width /
                                            (price.length * 7)))
                                        .toString())),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 60, 8, 8),
                              child: Text(
                                "INR",
                                style: TextStyle(color: Colors.yellow),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 270,
                    child: FloatingActionButton(
                      backgroundColor: PrimaryColors.backgroundColor,
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.yellow,
                        size: 60,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ]),
              ],
            ),
          ),

          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 6,
                child: Container(
                  height: 90,
                  width: 105,
                  child: Center(child: Text("TRANSACTIONS", style: TextStyle(color: Colors.white),)),
                ),
                onPressed: () {},
              ),
              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 6,
                child: Container(
                  height: 90,
                  width: 105,
                  child: Center(child: Text("WITHDRAWAL", style: TextStyle(color: PrimaryColors.backgroundColor),)),
                ),
                onPressed: () {},
              ),
            ],
          )

          //Divider(height: 10, thickness: 5,),
        ],
      ),
    ));
  }
}
