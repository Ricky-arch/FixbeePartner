import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/workscreen_bloc.dart';
import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/workscreen_model.dart';
import 'package:fixbee_partner/ui/custom_widget/work_animation.dart';
import 'package:fixbee_partner/ui/screens/billing_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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
  final String userId;
  final String phoneNumber;
  final String userProfilePicUrl;
  final String userProfilePicId;
  final String addressLine;
  final String landmark;
  final String serviceName;
  final int amount;
  final String timeStamp;
  final bool onServiceStarted;
  final bool cashOnDelivery;
  final int basePrice;
  final int serviceCharge;
  final int taxPercent;
  final String activeOrderStatus;

  const WorkScreen({
    Key key,
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
    this.onServiceStarted = false,
    this.userProfilePicId,
    this.cashOnDelivery,
    this.basePrice,
    this.serviceCharge,
    this.taxPercent,
    this.activeOrderStatus,
    this.userId,
  }) : super(key: key);
  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  WorkScreenBloc _bloc;
  bool _onNotificationReceivedForCompletionOfPayOnline = false;
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
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
      String validOtp = barcodeScanRes;
      if (barcodeScanRes != null) {
        _bloc.fire(WorkScreenEvents.verifyOtpToStartService,
            message: {"otp": validOtp, "orderId": widget.orderId},
            onHandled: (e, m) {
          _onServiceStarted = m.onServiceStarted;
         if(m.otpInvalidMessage!="")
           _showOtpInvalidBox(m.otpInvalidMessage);
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

  void _setupFCM() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    additionalReview = TextEditingController();
    rating = 5;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_MESSAGE');
        _getMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_RESUME');
        _getMessage(message);
      },
      onLaunch: (message) async {
        log(message.toString(), name: 'ON_LAUNCH');
        _getMessage(message);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _onServiceStarted = widget.onServiceStarted;
    String orderId = widget.orderId;
    _bloc = WorkScreenBloc(WorkScreenModel());
    log(widget.activeOrderStatus, name: "STATUS");
    _setupFCM();

    fetchLocationData().then((value) async {
      try {
        mapController.animateCamera(CameraUpdate.newLatLng(value));
        var marker =
            Marker(markerId: MarkerId("User Location"), position: value);
        setState(() {
          markers.add(marker);
        });
      } catch (e) {}
    });
    _refreshServiceDetails();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    _bloc.extinguish();
    super.dispose();
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
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "RATE USER",
                          style: TextStyle(
                              color: PrimaryColors.backgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
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
                            rating = value.toInt();
                            print(rating);
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
                        child: InkWell(
                          child: GestureDetector(
                            onTap: () {
                              log(
                                  additionalReview.text.toString() +
                                      rating.toString(),
                                  name: "REVIEW");
                              _bloc.fire(WorkScreenEvents.rateUser, message: {
                                'accountID': widget.userId,
                                'Score': rating,
                                'Review': additionalReview.text.toString()
                              }, onHandled: (e, m) {
                                Navigator.pop(context);
                              },);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0, 12, 12),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "CONFIRM",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                          border: Border.all(
                              color: PrimaryColors.backgroundColor, width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: (widget.userProfilePicId != null)
                              ? NetworkImage(
                                  widget.userProfilePicUrl,
                                )
                              : AssetImage("assets/custom_icons/user.png"),
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
                                  color: PrimaryColors.backgroundColor),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.orangeAccent,
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

              Container(
                child: Stack(
                  children: <Widget>[
                    Column(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
                              child: Text(
                                "Land-mark:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
                              child: Text(
                                "Service:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              width: 250,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Text(
                                  (widget.serviceName != null)
                                      ? allCsvServices()
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
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      child: GestureDetector(
                        onTap: (widget.activeOrderStatus != "RESOLVED")
                            ? () {
                                scanBarcode();
                              }
                            : null,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.orangeAccent.withOpacity(.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    (widget.activeOrderStatus != "RESOLVED")
                                        ? Icons.camera_alt
                                        : Icons.check_circle_outline,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    (widget.activeOrderStatus != "RESOLVED")
                                        ? "SCAN"
                                        : "SCANNED",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    InkWell(
                      child: GestureDetector(
                        onTap: () {
                          _showUserRatingModalSheet(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.orangeAccent.withOpacity(.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "RATE USER",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ),
                    ),
                    InkWell(
                      child: GestureDetector(
                        onTap: () {
                          _showJobInfoDialogBox();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.orangeAccent.withOpacity(.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "INFO",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              (widget.activeOrderStatus != "RESOLVED")
                  ? Expanded(
                      child: mapWidget = GoogleMap(
                      markers: markers,
                      onMapCreated: (GoogleMapController googleMapController) {
                        mapController = googleMapController;
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(38.8977, 77.0365), zoom: 16),
                    ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        WorkAnimation(),
                        SizedBox(
                          height: 40,
                        ),
                        (widget.cashOnDelivery)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: RaisedButton(
                                    elevation: 3,
                                    textColor: Colors.yellow,
                                    color: PrimaryColors.backgroundColor,
                                    onPressed: () {
                                      _showCompleteOrderDialogBoxForPayOnDelivery();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        "Done with the fixing?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        (!widget.cashOnDelivery)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: RaisedButton(
                                    elevation: 3,
                                    textColor: Colors.yellow,
                                    color: PrimaryColors.backgroundColor,
                                    onPressed: () {
                                      _showCompleteOrderDialogBoxForPayOnline();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        "Completed!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
            ],
          ));
        }),
      ),
    );
  }

  _showCompleteOrderDialogBoxForPayOnline() {
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
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return BillingScreen(
                      orderId: widget.orderId,
                      cashOnDelivery: widget.cashOnDelivery,
                      amount: widget.amount,
                      address: widget.addressLine,
                      userName: widget.userName,
                      status: 'COMPLETED',
                      timeStamp: widget.timeStamp,
                      serviceName: widget.serviceName,
                      serviceCharge: widget.serviceCharge,
                      basePrice: widget.basePrice,
                      taxPercent: widget.taxPercent,
                      addOns: _bloc.latestViewModel.jobModel.addons,
                    );
                  }));
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }

  _showCompleteOrderDialogBoxForPayOnDelivery() {
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
                  _bloc.fire(WorkScreenEvents.onJobCompletion,
                      message: {'orderID': widget.orderId}, onHandled: (e, m) {
                    print("Trying to complete");
                    if (m.onJobCompleted) {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) {
                        return BillingScreen(
                          orderId: widget.orderId,
                          cashOnDelivery: widget.cashOnDelivery,
                          amount: widget.amount,
                          address: widget.addressLine,
                          userName: widget.userName,
                          status: 'COMPLETED',
                          timeStamp: widget.timeStamp,
                          serviceName: widget.serviceName,
                          serviceCharge: widget.serviceCharge,
                          basePrice: widget.basePrice,
                          taxPercent: widget.taxPercent,
                          addOns: _bloc.latestViewModel.jobModel.addons,
                        );
                      }));
                    } else
                      Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text('Unable to complete order!')));
                  });
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
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            content: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(color: PrimaryColors.backgroundColor),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "JOB INFORMATION",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InfoPanel(
                        title: "Order Id:",
                        answer: widget.orderId.toUpperCase(),
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "User:",
                        answer: widget.userName,
                        maxLines: 1,
                      ),
                      VerticalDivider(),
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
                        answer: allCsvServices(),
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
              InkWell(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 12, 12),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.orangeAccent.withOpacity(.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                                2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "CLOSE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  _showOtpInvalidBox(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Text(
                message),
            actions: <Widget>[
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rescan",
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _getMessage(Map<String, dynamic> message) {
    Map notification = message['notification'];
    Map map = message['data'];
    String body = notification['body'];
    String m = map['redirect'];

    print(body + m);
    if (m == 'JOB_PROCESSED')
      _showPaymentReceivedNotification(body);
    else if (m == 'JOB_UPDATED')
      _refreshServiceDetails();
    else if (body == "You're Done!") {
      setState(() {
        _onNotificationReceivedForCompletionOfPayOnline = true;
      });
    } else
      _showJobCompletionNotificationForOnlinePayment(body);
  }

  _showPaymentReceivedNotification(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message,
              maxLines: null,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              )
            ],
          );
        });
  }

  _showJobCompletionNotificationForOnlinePayment(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message,
              maxLines: null,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return BillingScreen(
                      orderId: widget.orderId,
                      cashOnDelivery: widget.cashOnDelivery,
                      amount: widget.amount,
                      address: widget.addressLine,
                      userName: widget.userName,
                      status: 'COMPLETED',
                      timeStamp: widget.timeStamp,
                      serviceName: widget.serviceName,
                      serviceCharge: widget.serviceCharge,
                      basePrice: widget.basePrice,
                      taxPercent: widget.taxPercent,
                      addOns: _bloc.latestViewModel.jobModel.addons,
                    );
                  }));
                },

                //ADD BILLING SCREEN
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              )
            ],
          );
        });
  }

  _refreshServiceDetails() {
    _bloc.fire(WorkScreenEvents.refreshOrderDetails,
        message: {'orderID': widget.orderId});
  }

  String allCsvServices() {
    var addons = _bloc.latestViewModel.jobModel.addons;
    List<String> allServices = [widget.serviceName];
    if (addons == null || addons.isEmpty)
      return widget.serviceName;
    else {
      for (var addon in addons) {
        allServices.add(addon.serviceName);
      }
    }
    return allServices.join(', ');
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
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2 - 100,
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                answer,
                textAlign: TextAlign.end,
                maxLines: null,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
