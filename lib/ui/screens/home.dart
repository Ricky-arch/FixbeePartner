import 'dart:developer';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/home_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/home_events.dart';
import 'package:fixbee_partner/models/home_model.dart';
import 'package:fixbee_partner/ui/screens/verification_documents.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  final Function(bool state) onSwitchChangedState;
  const Home({Key key, this.onSwitchChangedState}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BitmapDescriptor customIcon;

// make sure to initialize before map loading

  static HomeBloc _bloc;
  static GoogleMapController mapController;
  static GoogleMap mapWidget;
  static Set<Marker> markers = Set();

  Future<bool> askForLocationPermissionIfDisabled() async {
    if (!await GeolocatorPlatform.instance.isLocationServiceEnabled())
      GeolocatorPlatform.instance.requestPermission();
    return true;
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets\logo\bee_white.png')
        .then((d) {
      customIcon = d;
    });
    super.initState();
    askForLocationPermissionIfDisabled();

    _bloc = HomeBloc(HomeModel());
    _bloc.onSwitchChange = widget.onSwitchChangedState;
    _bloc.fire(HomeEvents.activityStatusRequested, onHandled: (e, m) {
      log("Activeee: ${m.activeStatus}");
      if (m.activeStatus) {
      }
    });
    _bloc.fire(HomeEvents.getDocumentVerificationStatus);

    var marker = Marker(
        markerId: MarkerId("Center"),
        position: LatLng(23.829321, 91.277847));
    markers.add(marker);
    mapWidget = GoogleMap(
      myLocationEnabled: true,
      markers: markers,
      onMapCreated: (GoogleMapController googleMapController) {
        googleMapController.setMapStyle(Constants.MAP_STYLES);
        mapController = googleMapController;
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(23.829321, 91.277847), zoom: 15),
    );
  }

//  bool activeState=false ;

  @override
  void dispose() {
    _bloc?.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _bloc.widget(
          onViewModelUpdated: (ctx, viewModel) {
            return FutureBuilder<bool>(
                future: askForLocationPermissionIfDisabled(),
                builder: (context, snapshot) {
                  return (!snapshot.hasData)
                      ? CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: PrimaryColors.backgroundColor,
                                  boxShadow: [BoxShadow(color: Colors.brown)]),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("YOUR ACTIVITY STATUS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: (!viewModel.loading)
                                        ? Switch(
                                            value: viewModel.activeStatus,
                                            inactiveThumbColor: Colors.green,
                                            inactiveTrackColor: Colors.white,
                                            activeColor: Colors.red,
                                            onChanged: (bool value) {
                                              DataStore.me.active =
                                                  viewModel.activeStatus;
                                              if (value == true)
                                                askForLocationPermissionIfDisabled();
                                              if (value == false)
                                                // _bloc
                                                //     .unsubscribeToLocationUpdate();
                                                print(DataStore.token);
                                              _bloc.fire(HomeEvents
                                                  .getDocumentVerificationStatus);
                                              _bloc.fire(
                                                  HomeEvents.activityStatusSet,
                                                  message: {'status': value},
                                                  onHandled: (e, m) {
                                                widget.onSwitchChangedState(
                                                    m.activeStatus);
                                                if (m.activeStatus) {}
                                              });
                                            },
                                          )
                                        : SizedBox(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                              backgroundColor:
                                                  PrimaryColors.backgroundColor,
                                            ),
                                            height: 30,
                                            width: 30,
                                          ),
                                  )
                                ],
                              ),
                            ),
                            (viewModel.verifiedBee && viewModel.activeStatus)
                                ? Expanded(child: mapWidget)
                                : SizedBox(),
                            (!viewModel.activeStatus)
                                ? Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                      ),
                                      Center(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    "You are not an active Bee! ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: PrimaryColors
                                                            .backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Icon(
                                                  Icons.sentiment_dissatisfied,
                                                  color: Colors.deepPurple,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "Switch on the button above for a fly.",
                                                style: TextStyle(
                                                    color: PrimaryColors
                                                        .backgroundColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            (!viewModel.verifiedBee && viewModel.activeStatus)
                                ? Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                      ),
                                      Center(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    "It seems you are active but...",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: PrimaryColors
                                                            .backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Icon(
                                                  Icons.sentiment_neutral,
                                                  color: Colors.deepPurple,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "You are not verified, go to Profile for uploading documents",
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: PrimaryColors
                                                        .backgroundColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RaisedButton(
                                        color: Colors.yellow,
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (ctx) {
                                            return VerificationDocuments();
                                          }));
                                        },
                                        elevation: 2,
                                        child: Text(
                                          "Tap Here",
                                          style: TextStyle(
                                              color: PrimaryColors
                                                  .backgroundColor),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        );
                });
          },
        ),
      ),
    );
  }
}
