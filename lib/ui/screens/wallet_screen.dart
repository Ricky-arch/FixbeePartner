import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {

  const WalletScreen();
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Icon(Icons.monetization_on),
                      SizedBox(width: MediaQuery.of(context).size.width / 20),
                      Center(
                          child: Text(
                        "Wallet",
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
              //Divider(height: 10, thickness: 5,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: <TextSpan>[

                      TextSpan(
                        text: "Your wallet amount   ",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: "    Rs. 5000",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

              ),
              Divider(height: 10, thickness: 2,color: Colors.yellow[600],),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Text(
                            "Add to your Wallet?",
                            style: TextStyle(color: Colors.black, fontSize: 15),


                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Text(
                            "Bank Transfer?",
                            style: TextStyle(color: Colors.black, fontSize: 15),


                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
