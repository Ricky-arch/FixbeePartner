import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/ui/custom_widget/image_picker.dart';
import 'package:fixbee_partner/ui/screens/bank_details.dart';
import 'package:fixbee_partner/ui/screens/update_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile();
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Color.fromRGBO(3, 9, 23, 1),
            ),
            clipper: GetClipper(),
          ),
          Positioned(
            left: (MediaQuery.of(context).size.width / 2) - 75,
            top: 120 + ((MediaQuery.of(context).size.height / 4) - 135),
            child: Column(
              children: <Widget>[
                ImagePicker(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    DataStore.me.firstName + " " + DataStore.me.lastName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1d1b27)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    DataStore.me.ratings,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1d1b27)),
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment(0.0, 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 6,
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "40",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Jobs done",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width / 28),
                        ),
                      ],
                    )),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 4,
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "10",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Jobs declined",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width / 28),
                        ),
                      ],
                    )),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 6,
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "1000",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Wallet",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width / 28),
                        ),
                      ],
                    )),
                  ),
                ],
              )),
          Align(
              alignment: Alignment(0.0, 0.7),
              child: GestureDetector(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return UpdateProfile();
                              }));
                            },
                            child: Text(
                              "Update your Profile?",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    ),
                  ),
                ),
                onTap: () {},
              )),
          Align(
              alignment: Alignment(0.0, 0.83),
              child: GestureDetector(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Add your bank account?",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BankDetails()));
                },
              )),
        ],
      ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width + 150, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
