import 'dart:convert';
import 'dart:developer';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/workscreen_bloc.dart';
import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/workscreen_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_button_type1.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_button_type2.dart';
import 'package:fixbee_partner/ui/custom_widget/info_panel.dart';
import 'package:fixbee_partner/ui/custom_widget/info_panel2.dart';
import 'package:fixbee_partner/ui/custom_widget/work_animation.dart';
import 'package:fixbee_partner/ui/screens/billing_rating_screen.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final int quantity;
  final String activeOrderStatus;
  final int orderBasePrice;
  final int orderServiceCharge;
  final int orderDiscount;
  final int orderTaxCharge;
  final int orderAmount;

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
    this.quantity,
    this.orderBasePrice,
    this.orderServiceCharge,
    this.orderDiscount,
    this.orderTaxCharge,
    this.orderAmount,
  }) : super(key: key);
  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  WorkScreenBloc _bloc;
  bool _onNotificationReceivedForCompletionOfPayOnline = false;
  bool _onServiceStarted = false;
  DateTimeFormatter dtf;

  String gid, session, fields, key;
  String formattedAddress = "";
  String latitude, longitude;
  String barcode = "";

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
    setState(() {
      formattedAddress = locationData['result']['formatted_address'];
    });
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      log(barcode, name: "VALUE");
      if (barcode != null) {
        _bloc.fire(WorkScreenEvents.verifyOtpToStartService,
            message: {"otp": barcode, "orderId": widget.orderId},
            onHandled: (e, m) {
          _bloc.fire(WorkScreenEvents.checkActiveOrderStatus,
              message: {'orderID': widget.orderId});
          setState(() {
            _onServiceStarted = m.onServiceStarted;
          });
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  // Future<void> scanBarcode() async {
  //   String barcodeScanRes;
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "Cancel", true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //     String validOtp = barcodeScanRes;
  //     if (barcodeScanRes != null) {
  //       _bloc.fire(WorkScreenEvents.verifyOtpToStartService,
  //           message: {"otp": validOtp, "orderId": widget.orderId},
  //           onHandled: (e, m) {
  //         _bloc.fire(WorkScreenEvents.checkActiveOrderStatus,
  //             message: {'orderID': widget.orderId});
  //         setState(() {
  //           _onServiceStarted = m.onServiceStarted;
  //         });
  //       });
  //     }
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }

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
    dtf = DateTimeFormatter();
    _onServiceStarted = widget.onServiceStarted;
    String orderId = widget.orderId;
    _bloc = WorkScreenBloc(WorkScreenModel());
    _bloc.fire(WorkScreenEvents.checkActiveOrderStatus,
        message: {'orderID': widget.orderId});
    _bloc.fire(WorkScreenEvents.findUserRating,
        message: {"orderID": widget.orderId});
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _refreshServiceDetails();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: PrimaryColors.backgroundColor,
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
                                color: PrimaryColors.backgroundColor,
                                width: 2)),
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
                                  widget.userName.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: (viewModel.userRating == 0)
                                        ? 'User yet to be rated!'
                                        : "Rated " +
                                            viewModel.userRating
                                                .toStringAsFixed(1),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                      text: (viewModel.userRating != 0)
                                          ? " \u2605"
                                          : "",
                                      style: TextStyle(color: Colors.amber)),
                                ])),
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
                                    color: PrimaryColors.whiteColor,
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
                SizedBox(
                  height: 10,
                ),
                //Container(child: Text(widget.googlePlaceId),),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.tealAccent)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      InfoPanel2(
                        title: "ADDRESS:",
                        value: formattedAddress,
                      ),
                      InfoPanel2(title: "SERVICES:", value: allCsvServices()),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CustomButtonType2(
                        onTap: (viewModel.activeOrderStatus != "RESOLVED")
                            ? () {
                                scan();
                              }
                            : null,
                        text: (viewModel.activeOrderStatus != "RESOLVED")
                            ? "SCAN"
                            : "SCANNED",
                        icon: Icon(
                          (viewModel.activeOrderStatus != "RESOLVED")
                              ? Icons.camera_alt
                              : Icons.check_circle,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      CustomButtonType2(
                          text: "BASIC INFO",
                          onTap: () {
                            _showJobInfoDialogBox(formattedAddress);
                          },
                          icon: Icon(
                            Icons.info,
                            size: 18,
                            color: Colors.white,
                          )),
                      SizedBox(width: 10),
                      CustomButtonType2(
                          text: "ADD-ON INFO",
                          onTap: () {
                            _showJobInfoDialogBox(formattedAddress);
                          },
                          icon: Icon(
                            Icons.info,
                            size: 18,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),

                (viewModel.activeOrderStatus != "RESOLVED")
                    ? Expanded(
                        child: mapWidget = GoogleMap(
                        markers: markers,
                        onMapCreated:
                            (GoogleMapController googleMapController) {
                          googleMapController.setMapStyle(Constants.MAP_STYLES);
                          mapController = googleMapController;
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(38.8977, 77.0365), zoom: 16),
                      ))
                    : Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: PrimaryColors.backgroundColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              WorkAnimation(),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 5,
                              ),
                              (widget.cashOnDelivery)
                                  ? CustomButtonType1(
                                      onTap: () {
                                        _showCompleteOrderDialogBoxForPayOnDelivery();
                                      },
                                      flexibleSize: 0,
                                      text: "ARE YOU DONE?",
                                    )
                                  : Container(),
                              (!widget.cashOnDelivery)
                                  ? CustomButtonType1(
                                      onTap: () {
                                        _showCompleteOrderDialogBoxForPayOnline();
                                      },
                                      flexibleSize: 0,
                                      text: "COMPLETED BY USER",
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 12,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ));
          }),
        ),
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
                  _goToBillingScreen();
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
            content: Text(
              "Are you sure?",
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
                    "NO",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              ),
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () {
                  _bloc.fire(WorkScreenEvents.onJobCompletion,
                      message: {'orderID': widget.orderId}, onHandled: (e, m) {
                    print("Trying to complete");
                    if (m.onJobCompleted) {
                      _goToBillingScreen();
                    } else
                      Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text('Unable to complete order!')));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              )
            ],
          );
        });
  }

  _goToBillingScreen() {
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
      return BillingRatingScreen(
        userID: widget.userId,
        orderID: widget.orderId,
      );
    }));
  }

  _showJobInfoDialogBox(String formattedAddress) {
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
                            "BASIC INFORMATION",
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
                        answer: _bloc.latestViewModel.userRating
                                .toStringAsFixed(1) +
                            " \u2605",
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
                        answer: widget.quantity.toString(),
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Address:",
                        answer: formattedAddress,
                        maxLines: null,
                      ),
                      InfoPanel(
                        title: "Land-mark:",
                        answer: widget.landmark,
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Date",
                        answer: dtf.getDate(widget.timeStamp),
                        maxLines: null,
                      ),
                      InfoPanel(
                        title: "Time",
                        answer: dtf.getTime(widget.timeStamp),
                        maxLines: null,
                      )
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              CustomButtonType1(
                text: "CLOSE",
                flexibleSize: 70,
                onTap: () {
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
                  _goToBillingScreen();
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
