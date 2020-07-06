import 'dart:convert';
import 'dart:developer';

import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class WorkScreen extends StatefulWidget {
  final String userProfilePicUrl;
  final String userFirstname;
  final String userMiddlename;
  final String userLastname;
  final String userRating;
  final String userId;
  final String serviceName;
  final String locationId;
  final String locationName;
  final String addressLine;
  final String googlePlaceId;
  final String address;
  final String landmark;
  final String userPhoneNumber;
  final LatLng latLng;
  final String otp;
  final String serviceId;
  final bool priceable;
  final String basePrice;
  final String serviceCharge;
  final String taxPercent;
  final String graphQLId;
  final String orderId;
  final String status;
  final bool cashOnDelivery;
  final bool slotted;
  final DateTime slot;
  final String quantity;

  const WorkScreen(
      {Key key,
      this.userProfilePicUrl,
      this.userFirstname,
      this.userMiddlename,
      this.userLastname,
      this.userRating,
      this.userId,
      this.serviceName,
      this.locationId,
      this.locationName,
      this.addressLine,
      this.googlePlaceId,
      this.address,
      this.landmark,
      this.userPhoneNumber,
      this.latLng,
      this.otp,
      this.serviceId,
      this.priceable,
      this.basePrice,
      this.serviceCharge,
      this.taxPercent,
      this.graphQLId,
      this.orderId,
      this.status,
      this.cashOnDelivery,
      this.slotted,
      this.slot,
      this.quantity})
      : super(key: key);
  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  String gid, session, fields, key;
  String formattedAddress;
  String latitude, longitude;
  double lat, lng;

  String _scanBarcode = 'Unknown';
  int rating;
  TextEditingController otpController;
  TextEditingController additionalReview;
  bool isButtonEnabled = false;
  Map locationData;

  GoogleMapController mapController;
  GoogleMap mapWidget;
  Set<Marker> markers = Set();
  Geolocator geoLocator = Geolocator();
  //lat: 23.8086376,lng: 91.2612741,

  fetchLocationData() async {
    gid = widget.googlePlaceId;
    session = Constants.googleSessionToken;
    fields = Constants.fields;
    key = Constants.googleApiKey;
    //https://maps.googleapis.com/maps/api/place/details/json?place_id=$gid&fields=$fields&key=$key&sessiontoken=$session
    //https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJizXpb6X1UzcRA5qlSx3e5Ak&fields=name,formatted_address,geometry&key=AIzaSyBOtIGTYgsxiCKVDAXWy9ZPU0rUPr2P8sI&sessiontoken=12345
    http.Response response = await http.get(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJizXpb6X1UzcRA5qlSx3e5Ak&fields=name,formatted_address,geometry&key=AIzaSyBOtIGTYgsxiCKVDAXWy9ZPU0rUPr2P8sI&sessiontoken=12345');
    setState(() {
      locationData = json.decode(response.body);

      print("xxxxx" + locationData.toString());
      latitude =
          locationData['result']['geometry']['location']['lat'].toString();
      longitude =
          locationData['result']['geometry']['location']['lng'].toString();
      print("xxx" +
          locationData['result']['geometry']['location']['lng'].toString());
      lat = double.parse(latitude);
      lng = double.parse(longitude);
    });
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLocationData();

    otpController = TextEditingController();

    var marker = Marker(
        markerId: MarkerId("User Location"),
        position: LatLng(
            lat == null ? 23.8086376 : lat, lng == null ? 91.2612741 : lng));
    markers.add(marker);
    mapWidget = GoogleMap(
      markers: markers,
      onMapCreated: (GoogleMapController googleMapController) {
        mapController = googleMapController;
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(
              lat == null ? 23.8086376 : lat, lng == null ? 91.2612741 : lng),
          zoom: 16),
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
          return Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Wrap(
                  children: [
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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6)
                              ],
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
                )
              ],
            ),
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
          return ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Rate User",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RatingBar(
                      itemCount: 5,
                      initialRating: 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          case 4:
                            return Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            );
                        }
                        return Container();
                      },
                      onRatingUpdate: (double value) {
                        print(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add an additional review?",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: TextFormField(
                      controller: additionalReview,
                      decoration: InputDecoration(hintText: "Write here..."),
                      maxLines: null,
                      textAlign: TextAlign.left,
                      autofocus: false,
                      enabled: true,
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(60)],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: RaisedButton(
                    color: Colors.pink,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ))
                ],
              )
            ],
          );
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
          Expanded(
              child: Stack(
            children: [
              lat == null ? CircularProgressIndicator() : mapWidget,
              Positioned(
                left: 300,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    size: 40,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  onPressed: () {
                    _showNewJobDialogBox();
                  },
                ),
              ),
              Positioned(
                top: 45,
                left: 240,
                child: RaisedButton(
                  color: Colors.green.withOpacity(.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Scan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    scanBarcode();
                    print(_scanBarcode + " Barcode");
                  },
                ),
              )
            ],
          )),
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

  _showNewJobDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Accept the New Job?"),
            actions: [
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
