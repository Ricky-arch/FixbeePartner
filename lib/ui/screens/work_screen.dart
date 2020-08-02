import 'dart:convert';

import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/workscreen_bloc.dart';
import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/workscreen_model.dart';
import 'package:fixbee_partner/ui/custom_widget/work_animation.dart';
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
  final String orderId;
  final String googlePlaceId;
  final String userName;
  final String phoneNumber;
  final String userProfilePicUrl;
  final String userProfilePicId;
  final String addressLine;
  final String landmark;
  final String serviceName;
  final int amount;
  final String timeStamp;
  final bool onServiceStarted;

  const WorkScreen(
      {Key key,
      this.orderId,
      this.googlePlaceId,
      this.userName,
      this.phoneNumber,
      this.userProfilePicUrl,
      this.addressLine,
      this.landmark,
      this.serviceName,
      this.amount,
      this.timeStamp,
      this.onServiceStarted = false, this.userProfilePicId})
      : super(key: key);
  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  WorkScreenBloc _bloc;
  bool _onServiceStarted;

  String gid, session, fields, key;
  String formattedAddress;
  String latitude, longitude;

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

  Future<LatLng> fetchLocationData() async {
    double lat, lng;
    gid = widget.googlePlaceId;
    session = Constants.googleSessionToken;
    fields = Constants.fields;
    key = Constants.googleApiKey;
    http.Response response = await http.get(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$gid&fields=$fields&key=$key&sessiontoken=$session');
    locationData = json.decode(response.body);
    if (locationData != null) {
      latitude =
          locationData['result']['geometry']['location']['lat'].toString();
      longitude =
          locationData['result']['geometry']['location']['lng'].toString();
    }
    print("xxx" +
        locationData['result']['geometry']['location']['lng'].toString());
    lat = double.parse(latitude);
    lng = double.parse(longitude);
    LatLng ltng = LatLng(lat, lng);
    return ltng;
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
      int otp = int.parse(barcodeScanRes);
      if (otp != null) {
        _bloc.fire(WorkScreenEvents.verifyOtpToStartService,
            message: {"otp": otp, "orderId": widget.orderId},
            onHandled: (e, m) {
          _onServiceStarted = m.onServiceStarted;
        });
      }
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
    _onServiceStarted = widget.onServiceStarted;
    String orderId = widget.orderId;
    _bloc = WorkScreenBloc(WorkScreenModel());

    fetchLocationData().then((value) async {
      mapController.animateCamera(CameraUpdate.newLatLng(value));
      var marker = Marker(markerId: MarkerId("User Location"), position: value);
      setState(() {
        markers.add(marker);
      });
    });

    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    _bloc.extinguish();
    super.dispose();
  }

  _showOtpModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.deepPurple),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Enter Otp",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
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
                        textColor: Colors.deepPurple,
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
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
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
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.deepPurple),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Rate User",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
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
                          decoration:
                              InputDecoration(hintText: "Write here..."),
                          maxLines: null,
                          textAlign: TextAlign.left,
                          autofocus: false,
                          enabled: true,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: RaisedButton(
                        color: Colors.deepPurple,
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
                  ),
                )
              ],
            ),
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return SafeArea(
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
                          border:
                              Border.all(color: Colors.deepPurple, width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: (widget.userProfilePicId != null)
                              ? NetworkImage(
                                  widget.userProfilePicUrl,
                                )
                              : NetworkImage(
                                  'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                        ),
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
                                widget.userName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
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
                                  color: Colors.deepPurple),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                onTap: () =>
                                    launch("tel://${widget.phoneNumber}"),
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
              //Container(child: Text(widget.googlePlaceId),),

              _onServiceStarted
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        WorkAnimation(),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : Container(
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 8, 8, 8),
                                    child: Text(
                                      "Address:",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                      child: Text(
                                        (widget.addressLine != null)
                                            ? widget.addressLine
                                            : "Ram Mandir",
                                        maxLines: null,
                                        //textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 8, 8),
                                    child: Text(
                                      "Land-mark:",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Text(
                                        (widget.landmark != null)
                                            ? widget.landmark
                                            : "Ram Mandir",
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 8, 8),
                                    child: Text(
                                      "Service:",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Text(
                                        (widget.serviceName != null)
                                            ? widget.serviceName
                                            : "Work",
                                        //textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                              left: MediaQuery.of(context).size.width - 60,
                              top: 50,
                              child: IconButton(
                                icon: Icon(
                                  Icons.info,
                                  color: Colors.deepPurple,
                                ),
                                onPressed: () {
                                  _showJobInfoDialogBox();
                                },
                              ))
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
                            scanBarcode();
                            print(_scanBarcode + " Barcode");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
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
                  mapWidget = GoogleMap(
                    markers: markers,
                    onMapCreated: (GoogleMapController googleMapController) {
                      mapController = googleMapController;
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(38.8977, 77.0365), zoom: 16),
                  ),
                  Positioned(
                    left: 300,
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 40,
                        color: Colors.deepPurple.withOpacity(0.5),
                      ),
                      onPressed: () {
                        _showNewJobDialogBox();
                      },
                    ),
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: OutlineButton(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                    textColor: Colors.deepPurple,
                    color: Colors.green,
                    onPressed: () {
                      _showAlertDialogBox();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Done with the fixing?",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
        }),
      ),
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

  _showJobInfoDialogBox() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.deepPurple),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Job Information",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InfoPanel(
                        title: "User:",
                        answer: widget.userName,
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Rated:",
                        answer: "Unrated",
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Phone Number:",
                        answer: widget.phoneNumber,
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Service:",
                        answer: widget.serviceName,
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Quantity:",
                        answer: "1",
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Address:",
                        answer: widget.addressLine,
                        maxLines: null,
                      ),
                      InfoPanel(
                        title: "Land-mark:",
                        answer: widget.landmark,
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "T-S:",
                        answer: widget.timeStamp,
                        maxLines: null,
                      )
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.purple,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
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

class InfoPanel extends StatelessWidget {
  final String title, answer;
  final int maxLines;

  const InfoPanel({Key key, this.title, this.answer, this.maxLines})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              answer,
              textAlign: TextAlign.start,
              maxLines: maxLines,
              style: TextStyle(color: Colors.black, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
