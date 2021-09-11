import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/workscreen_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/workscreen_event.dart';
import 'package:fixbee_partner/models/orders_model.dart';
import 'package:fixbee_partner/models/workscreen_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_button_type1.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_button_type2.dart';
import 'package:fixbee_partner/ui/custom_widget/info_panel.dart';
import 'package:fixbee_partner/ui/custom_widget/info_panel2.dart';
import 'package:fixbee_partner/ui/custom_widget/work_animation.dart';
import 'package:fixbee_partner/ui/screens/billing_rating_screen.dart';
import 'package:fixbee_partner/ui/screens/order_chat.dart';
import 'package:fixbee_partner/ui/screens/order_images.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:majascan/majascan.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

import 'navigation_screen.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  WorkScreenBloc _bloc;
  final GlobalKey<FormState> _formOTP = GlobalKey<FormState>();
  bool _onServiceStarted = false;
  DateTimeFormatter dtf;
  String gid, session, fields, key;
  String formattedAddress = "";
  String latitude, longitude;
  String barcode = "";
  bool showNotification = true;

  String _scanBarcode = 'Unknown';
  String result = "Hey there !";
  int rating;
  TextEditingController otpController;
  TextEditingController additionalReview;
  bool isButtonEnabled = false;
  Map locationData;

  GoogleMapController mapController;
  GoogleMap mapWidget;
  Set<Marker> markers = Set();
  Geolocator geoLocator = Geolocator();

  bool _isErrorOnLoadingUserPicture = false;

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

    lat = double.parse(latitude);
    lng = double.parse(longitude);
    LatLng ltng = LatLng(lat, lng);
    return ltng;
  }

  Future _scanQR() async {
    try {
      String qrResult = await MajaScan.startScan(
          scanAreaScale: .7,
          title: "Order OTP Scanner",
          titleColor: PrimaryColors.yellowColor,
          qRCornerColor: Colors.orange,
          qRScannerColor: Colors.orange);
      setState(() {
        result = qrResult;
      });
      if (result != null || result.isNotEmpty) {
        bool valid = await _bloc.verifyOtpToStartService(result);
        if (valid) {
          _showMessageDialog('Otp Valid!');
          setState(() {
            _bloc.latestViewModel.activeOrderStatus = 'in progress';
          });
        } else
          _showMessageDialog('Otp Invalid!');
      }
    } on PlatformException catch (ex) {
      if (ex.code == MajaScan.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  void _setupFCM() {
    List<String> redirectList = [
      'LOW_WALLET_BALANCE',
      'JOB_UPDATE',
      'PHOTO_REMOVED',
      'PHOTO_UPLOAD',
      'ADDONS_ADDED',
      'JOB_UPDATE',

    ];
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    additionalReview = TextEditingController();
    rating = 5;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        FlutterRingtonePlayer.playNotification();
        log(message.toString(), name: 'ON_MESSAGE');
        if (redirectList.contains(message['data']['redirect'].toString()) &&
            showNotification) {
          if (message['data']['redirect'] == 'ADDONS_ADDED')
            _refreshServiceDetails();

          _showMessageDialog(message['notification']['body']);
        } else if (message['data']['redirect'] == 'JOB_CANCEL')
          _showCancelDialog(message['notification']['body']);
        else if (message['data']['redirect']=='ORDER_COMPLETE' && !widget.orderModel.cashOnDelivery){
          _showOrderCompletionSuccessDialog();
          Future.delayed(Duration(seconds: 5), () {
            _goToBillingScreen();
          });
        }

      },
      onResume: (Map<String, dynamic> message) async {
        log(message.toString(), name: 'ON_RESUME');

        if (redirectList.contains(message['data']['redirect'].toString()) &&
            showNotification) {
          if (message['data']['redirect'] == 'ADDONS_ADDED')
            _refreshServiceDetails();
          _showMessageDialog(message['notification']['body']);
        } else if (message['data']['redirect'] == 'JOB_CANCEL')
          _showCancelDialog(message['notification']['body']);
        else if (message['data']['redirect']=='ORDER_COMPLETE' && !widget.orderModel.cashOnDelivery){
          _showOrderCompletionSuccessDialog();
          Future.delayed(Duration(seconds: 5), () {
            _goToBillingScreen();
          });
        }
      },
      onLaunch: (message) async {
        log(message.toString(), name: 'ON_LAUNCH');
        if (redirectList.contains(message['data']['redirect'].toString()) &&
            showNotification) {
          if (message['data']['redirect'] == 'ADDONS_ADDED')
            _refreshServiceDetails();
          _showMessageDialog(message['notification']['body']);
        } else if (message['data']['redirect'] == 'JOB_CANCEL')
          _showCancelDialog(message['notification']['body']);
        else if (message['data']['redirect']=='ORDER_COMPLETE' && !widget.orderModel.cashOnDelivery){
          _showOrderCompletionSuccessDialog();
          Future.delayed(Duration(seconds: 5), () {
            _goToBillingScreen();
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    dtf = DateTimeFormatter();
    String orderId = widget.orderModel.id;
    _bloc = WorkScreenBloc(WorkScreenModel());
    _bloc.fire(WorkScreenEvents.checkActiveOrderStatus);
    _bloc.startTimer();
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
        key: _scaffoldKey,
        floatingActionButton: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return OrderImages();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      LineAwesomeIcons.images,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return OrderChat();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.chat,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (widget.orderModel.cashOnDelivery) {
                  if (_bloc.latestViewModel.activeOrderStatus ==
                      'in progress') {
                    _bloc.fire(WorkScreenEvents.fetchOrderPayment,
                        message: {'id': widget.orderModel.id},
                        onHandled: (e, m) async {
                      bool orderEndRequested =
                          await _showPaymentSheet(context, m.payment) ?? false;
                      if (orderEndRequested) {
                        setState(() {
                          showNotification = false;
                        });
                        _bloc.fire(WorkScreenEvents.receivePayment,
                            onHandled: (e, m) {
                          if (m.paymentReceived) {
                            _showOrderCompletionSuccessDialog();
                            Future.delayed(Duration(seconds: 5), () {
                              _goToBillingScreenCOD();
                            });
                          } else {
                            _showMessageDialog(
                                m?.receivePaymentError?.toString() ?? 'Error');
                          }
                        });
                      }
                    });
                  } else {
                    _showMessageDialog(
                        'Order cannot be completed until resolved for Pay On Work Done!');
                  }
                } else {
                  _goToBillingScreen();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      LineAwesomeIcons.receipt,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Active  ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(
                        text: "Order",
                        style: TextStyle(
                            fontSize: 26,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,
                                radius: 25,
                                onBackgroundImageError: (_, __) {
                                  setState(() {
                                    this._isErrorOnLoadingUserPicture = true;
                                  });
                                },
                                child: _isErrorOnLoadingUserPicture
                                    ? Image.asset(
                                        "assets/custom_icons/user.png")
                                    : null,
                                backgroundImage: (widget
                                            .orderModel.user.profilePicId !=
                                        null)
                                    ? NetworkImage(
                                        EndPoints.DOCUMENT +
                                            widget.orderModel.user.profilePicId,
                                        headers: {
                                            'authorization':
                                                '${DataStore.token}'
                                          })
                                    : AssetImage(
                                        "assets/custom_icons/user.png"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            child: Text(
                              widget.orderModel.user.firstname,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 8, bottom: 8),
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
              SizedBox(
                height: 10,
              ),
              //Container(child: Text(widget.googlePlaceId),),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButtonType2(
                        text: "BASIC INFO",
                        onTap: () {
                          _showJobInfoDialogBox(formattedAddress);
                        },
                        icon: Icon(
                          Icons.info,
                          size: 18,
                          color: Theme.of(context).canvasColor,
                        )),
                    SizedBox(width: 10),
                    CustomButtonType2(
                      onTap: (viewModel.activeOrderStatus != "in progress")
                          ? () async {
                              var otp = await _verifyOtpSheet(context);
                              if (otp != null && otp.isNotEmpty) {
                                bool valid = await _bloc
                                    .verifyOtpToStartService(otp.toString());
                                if (valid) {
                                  _showMessageDialog('Otp Valid!');
                                  setState(() {
                                    _bloc.latestViewModel.activeOrderStatus =
                                        'in progress';
                                  });
                                } else
                                  _showMessageDialog('Otp Invalid!');
                              }
                            }
                          : null,
                      text: (viewModel.activeOrderStatus != "in progress")
                          ? "VERIFY"
                          : "VERIFIED",
                      icon: Icon(
                        (viewModel.activeOrderStatus != "in progress")
                            ? Icons.info
                            : Icons.check_circle,
                        size: 18,
                        color: (viewModel.activeOrderStatus != "in progress")
                            ? Theme.of(context).errorColor
                            : Theme.of(context).canvasColor,
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
                          color: Theme.of(context).canvasColor,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              (viewModel.receivingPayment)
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor),
                      backgroundColor: Theme.of(context).canvasColor,
                    )
                  : SizedBox(),
              (viewModel.fetchingPaymentAmount)
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor),
                      backgroundColor: Theme.of(context).canvasColor,
                    )
                  : SizedBox(),
              (viewModel.activeOrderStatus != "in progress")
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          WorkAnimation(),
                        ],
                      ),
                    ),
            ],
          ));
        }),
      ),
    );
  }

  _dialogForPayOnWorkDone() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            content: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Are you done?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16),
                ),
                TextSpan(
                    text:
                        "\nPay on work done cannot be reverted after bill is fetched..",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 14))
              ]),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Theme.of(context).canvasColor,
                onPressed: () async {
                  Navigator.pop(context, false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NO",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              RaisedButton(
                color: Theme.of(context).canvasColor,
                onPressed: () async {
                  Navigator.pop(context, true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              )
            ],
          );
        });
  }

  _goToBillingScreen() {
    if (!widget.orderModel.cashOnDelivery) _bloc.endTimer();
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return BillingRatingScreen(
        orderId: widget.orderModel.id,
        cashOnDelivery: widget.orderModel.cashOnDelivery,
      );
    }));
  }

  _goToBillingScreenCOD() {
    if (!widget.orderModel.cashOnDelivery) _bloc.endTimer();
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
      return BillingRatingScreen(
        orderId: widget.orderModel.id,
        cashOnDelivery: widget.orderModel.cashOnDelivery,
      );
    }));
  }

  _showOrderCompletionSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          FlutterRingtonePlayer.playNotification();
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              height: 250,
              width: 250,
              child: FlareActor(
                "assets/animations/cms_remix.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Untitled",
              ),
            ),
          );
        });
  }

  _verifyOtpSheet(context) {
    return showModalBottomSheet(
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
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: Theme.of(context).cardColor),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 8),
                            child: Text(
                              "VERIFY ORDER",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Form(
                                  key: _formOTP,
                                  child: TextFormField(
                                    cursorColor: Theme.of(context).accentColor,
                                    validator: (value) {
                                      if (value.trim().isNotEmpty) {
                                        if (!isNumeric(value))
                                          return 'Only digits accepted!';
                                      }
                                      if (value.isEmpty || value.length < 6) {
                                        return 'Otp cannot be less than 6 digits';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "Enter 6 digit OTP",
                                      fillColor: Theme.of(context).cardColor,
                                      filled: true,
                                      errorStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    controller: otpController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formOTP.currentState.validate()) {
                                Navigator.pop(
                                    context, otpController.text ?? null);
                                otpController.clear();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "Verify",
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          OutlineButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            borderSide: BorderSide(
                                width: 2, color: Theme.of(context).accentColor),
                            textColor: PrimaryColors.backgroundColor,
                            onPressed: () {
                              otpController.clear();
                              Navigator.pop(context, null);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  _showAddOnInfoDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
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
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              )),
                            )
                          : ListView.builder(
                              itemCount: _bloc
                                  .latestViewModel.ordersModel.addOns.length,
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
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
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
                        answer: (widget.orderModel.quantity != null)
                            ? widget.orderModel.quantity.toString()
                            : "1",
                        maxLines: 1,
                      ),
                      InfoPanel(
                        title: "Address:",
                        answer:
                            widget.orderModel.address.split('Landmark:')[0] ??
                                "Test",
                        maxLines: null,
                      ),
                      InfoPanel(
                        title: "Land-Mark:",
                        answer:
                            widget.orderModel.address.split('Landmark:')[1] ??
                                "Test",
                        maxLines: null,
                      ),
                      InfoPanel(
                        title: "Formatted-Address:",
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
    if (notification['body'] != null) {
      String body = notification['body'];
      String m = map['redirect'];
      if (m == 'JOB_CANCEL') _showCancelDialog(body);
    }
  }

  _showMessageDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: Theme.of(context).canvasColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          );
        });
  }

  _showCancelDialog(message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: Theme.of(context).canvasColor,
            content: Text(
              'Order has been cancelled!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).errorColor),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => NavigationScreen());
                  Navigator.pushAndRemoveUntil(context, route, (e) => false);
                },
                color: Theme.of(context).canvasColor,
                child: Text('OK'),
                textColor: Theme.of(context).primaryColor,
              )
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

  _showPaymentSheet(context, int amount) {
    return showModalBottomSheet(
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Theme.of(context).cardColor),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12.0, 8, 12, 8),
                              child: Text(
                                "ORDER PAYMENT",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: Constants.rupeeSign + "\t",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 22)),
                                TextSpan(
                                    text: (amount / 100).toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: amount.toString().length *
                                            (MediaQuery.of(context).size.width /
                                                (amount.toString().length *
                                                    5)))),
                              ]))),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, top: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Dismissible(
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  Navigator.pop(context, true);
                                } else {
                                  Navigator.pop(context, false);
                                }
                              },
                              background: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                alignment: Alignment.centerLeft,
                                color: Colors.red,
                                child: Text(
                                  'END',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              secondaryBackground: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                alignment: Alignment.centerRight,
                                color: Colors.green,
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SWIPE RIGHT TO END ORDER',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.arrow_right_alt_rounded,
                                        color: Theme.of(context).canvasColor,
                                      )
                                    ],
                                  ))),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 12, top: 8),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "\u2139\t",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              TextSpan(
                                  text:
                                      "Pay on work done cannot be reverted after end.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 14))
                            ]),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
