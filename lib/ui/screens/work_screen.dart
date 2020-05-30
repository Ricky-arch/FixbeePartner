import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkScreen extends StatefulWidget {
  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  TextEditingController otpController;
  bool isButtonEnabled = false;

  GoogleMapController mapController;
  GoogleMap mapWidget;
  Set<Marker> markers = Set();
  Geolocator geoLocator = Geolocator();

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();

    var marker = Marker(
        markerId: MarkerId("User Location"),
        position: LatLng(23.829321, 91.277847));
    markers.add(marker);
    mapWidget = GoogleMap(
      markers: markers,
      onMapCreated: (GoogleMapController googleMapController) {
        mapController = googleMapController;
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(23.829321, 91.277847), zoom: 18),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  _showOtpModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Enter Otp from User",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: isOtpValid,
                        decoration: InputDecoration(
                            hintText: "Type Here",
                            errorStyle: TextStyle(color: Colors.red),
                            border: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.green))),
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(6)],
                      ),
                    ),
                  ),
                  OutlineButton(
                    borderSide: BorderSide(width: 2, color: Colors.green),
                    textColor: Colors.green,
                    onPressed: isButtonEnabled
                        ? () {
                            Navigator.pop(context);
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Check Otp",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _showCancelModalSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container();
        });
  }

  _showUserRatingModalSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container();
        });
  }

  void isOtpValid(String value) {
    setState(() {
      if (value.toString().trim().length == 6 && isNumeric(value.toString())) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 114,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Donald Trump',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('Rated 4.5 stars'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green),
                          child: GestureDetector(
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            onTap: () {
                              _callPhone("tel:+918132802897");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                      child: Text(
                        "Address:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Text(
                          "Battala, Agartala, Tripura(West), Pin-777777, India(North-East), Asia, Earth, Solar System",
                          maxLines: null,
                          //textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
                      child: Text(
                        "Land-Mark:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Text(
                          "Battala Shoshan",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                      child: Text(
                        "Work:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Text(
                          "Plumbing",
                          maxLines: null,
                          //textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                      child: Text(
                        "Quantity:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Text(
                          "1",
                          maxLines: null,
                          //textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      textColor: Colors.white,
                      color: Color.fromRGBO(3, 9, 23, 1),
                      onPressed: () {
                        _showOtpModalBottomSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "Enter Otp",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Color.fromRGBO(3, 9, 23, 1),
                      onPressed: () {
                        _showUserRatingModalSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "Rate User",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Color.fromRGBO(3, 9, 23, 1),
                      onPressed: () {
                        _showCancelModalSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(child: mapWidget),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: RaisedButton(
                elevation: 5,
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  _showAlertDialogBox();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    "Done with the fixing?",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  _callPhone(phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  _showAlertDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Are you sure?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationScreen()));
                },
                child: Text("Yes"),
              ),
            ],
          );
        });

  }
}
