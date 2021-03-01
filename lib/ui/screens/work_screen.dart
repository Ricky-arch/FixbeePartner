import 'dart:convert';
import 'dart:developer';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/workscreen_bloc.dart';
import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/orders_model.dart';
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
  final Orders orderModel;

  const WorkScreen({
    Key key,
    this.orderModel,
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
    gid = widget.orderModel.placeId;
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
            message: {"otp": barcode}, onHandled: (e, m) {
          if (!m.otpValid)
            _showOtpValidityDialog('Otp Invalid!');
          else if (m.otpValid)
            {
              _showOtpValidityDialog('Otp Validated!');
              setState(() {
                _onServiceStarted = m.onServiceStarted;
              });
            }

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
    // _onServiceStarted = widget.onServiceStarted;
    String orderId = widget.orderModel.id;
    _bloc = WorkScreenBloc(WorkScreenModel());

    _bloc.fire(WorkScreenEvents.checkActiveOrderStatus);

    _bloc.startTimer();

    log(widget.orderModel.status, name: "STATUS");
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
    print(widget.orderModel.otp + "OTP");
  }

  @override
  void dispose() {
    otpController.dispose();
    _bloc.endTimer();
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _refreshServiceDetails();
        _bloc.fire(WorkScreenEvents.checkActiveOrderStatus);
      },
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
                              color: PrimaryColors.backgroundColor, width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              (widget.orderModel.user.profilePicId != null)
                                  ? NetworkImage(
                                      widget.orderModel.user.profilePicId,
                                    )
                                  : AssetImage("assets/custom_icons/user.png"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: Text(
                              widget.orderModel.user.firstname.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 8, bottom: 8),
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
                                onTap: () => launch(
                                    "tel://${widget.orderModel.user.phoneNumber}"),
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
                        text: "ADD-ON INFO",
                        onTap: () {
                           _showAddOnInfoDialogBox();
                        },
                        icon: Icon(
                          Icons.info,
                          size: 18,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              (viewModel.activeOrderStatus != "RESOLVED")
                  ? Expanded(
                      child: mapWidget = GoogleMap(
                      markers: markers,
                      onMapCreated: (GoogleMapController googleMapController) {
                        googleMapController.setMapStyle(Constants.MAP_STYLES);
                        mapController = googleMapController;
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(38.8977, 77.0365), zoom: 16),
                    ))
                  : Expanded(
                      child: Container(
                        decoration:
                            BoxDecoration(color: PrimaryColors.backgroundColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            WorkAnimation(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 5,
                            ),
                            (widget.orderModel.cashOnDelivery)
                                ? CustomButtonType1(
                                    onTap: () {
                                      _showCompleteOrderDialogBoxForPayOnDelivery();
                                    },
                                    flexibleSize: 0,
                                    text: "ARE YOU DONE?",
                                  )
                                : Container(),
                            (!widget.orderModel.cashOnDelivery)
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
              (widget.orderModel.cashOnDelivery)
                  ? RaisedButton(
                      color: PrimaryColors.backgroundColor,
                      onPressed: () {
                        // _bloc.fire(WorkScreenEvents.onJobCompletion,
                        //     message: {'orderID': widget.orderModel.id},
                        //     onHandled: (e, m) {
                        //   print("Trying to complete");
                        //   if (m.onJobCompleted) {
                        //     _goToBillingScreen();
                        //   } else
                        //     Scaffold.of(context).showSnackBar(new SnackBar(
                        //         content:
                        //             new Text('Unable to complete order!')));
                        // });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "YES",
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        });
  }

  _goToBillingScreen() {
    _bloc.endTimer();
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
      return BillingRatingScreen(
          // userID: widget.orderModel.id,
          // orderID: widget.orderModel.,
          );
    }));
  }

  _showAddOnInfoDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          log(_bloc.latestViewModel.ordersModel.addOns.length.toString(),
              name: "SIZE");
          return Dialog(
            backgroundColor: PrimaryColors.backgroundColor,
            child: Wrap(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ADD-ON INFORMATION",
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      (_bloc.latestViewModel.ordersModel.addOns.length == 0)
                          ? Container(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                "User did not request for any add-on!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )),
                            )
                          : ListView.builder(
                              itemCount:
                                  _bloc.latestViewModel.ordersModel.addOns.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                  child: InfoPanel(
                                    title: "ADD-ON ${index + 1}",
                                    answer: _bloc.latestViewModel.ordersModel
                                            .addOns[index].serviceName +
                                        " (X) " +
                                        _bloc.latestViewModel.ordersModel
                                            .addOns[index].quantity
                                            .toString(),
                                    maxLines: 1,
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _showJobInfoDialogBox(String formattedAddress) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: PrimaryColors.backgroundColor,
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            content: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "BASIC INFORMATION",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      InfoPanel(
                        title: "User:",
                        answer: widget.orderModel.user.firstname,
                        maxLines: 1,
                      ),
                      VerticalDivider(),
                      InfoPanel(
                        title: "Phone Number:",
                        answer: widget.orderModel.user.phoneNumber,
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Service:",
                        answer: allCsvServices(),
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Quantity:",
                        answer: (widget.orderModel.quantity!=null)?widget.orderModel.quantity.toString():"1",
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Address:",
                        answer: formattedAddress,
                        maxLines: null,
                      ),
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

  _showOtpValidityDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
            actions: [
              (widget.orderModel.cashOnDelivery)
                  ? RaisedButton(
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
                  : SizedBox(),
            ],
          );
        });
  }

  _refreshServiceDetails() {
    _bloc.fire(WorkScreenEvents.refreshOrderDetails);
  }

  String allCsvServices() {
    var addons = _bloc.latestViewModel.ordersModel.addOns;
    List<String> allServices = [widget.orderModel.serviceName];
    if (addons == null || addons.isEmpty)
      return widget.orderModel.serviceName;
    else {
      for (var addon in addons) {
        allServices.add(addon.serviceName);
      }
    }
    return allServices.join(', ');
  }
}
