
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/home_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/home_events.dart';
import 'package:fixbee_partner/models/home_model.dart';
import 'package:fixbee_partner/ui/screens/verification_documents.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  final Function(bool state) onSwitchChangedState;
  const Home({Key key, this.onSwitchChangedState}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BitmapDescriptor customIcon;

  static HomeBloc _bloc;
  static GoogleMapController mapController;
  static GoogleMap mapWidget;
  static Set<Marker> markers = Set();

  Box _BEENAME;
  _openHive() {
    _BEENAME = Hive.box<String>("BEE");
  }

  Future<bool> askForLocationPermissionIfDisabled() async {
    if (!await GeolocatorPlatform.instance.isLocationServiceEnabled())
      GeolocatorPlatform.instance.requestPermission();
    return true;
  }

  @override
  void initState() {
    _openHive();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)), 'assets\logo\bee_white.png')
        .then((d) {
      customIcon = d;
    });
    super.initState();
    askForLocationPermissionIfDisabled();
    _bloc = HomeBloc(HomeModel());
    _bloc.onSwitchChange = widget.onSwitchChangedState;
    _bloc.fire(HomeEvents.getDocumentVerificationStatus);

    var marker = Marker(
        markerId: MarkerId("Center"),
        position: LatLng(23.829321, 91.277847),
        icon: customIcon);
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
            return Column(
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
                            ? ValueListenableBuilder(
                                valueListenable: _BEENAME.listenable(),
                                builder: (context, box, _) {
                                  return Switch(
                                    value: (_BEENAME.get("myActiveStatus") ==
                                            "true")
                                        ? true
                                        : false,
                                    inactiveThumbColor: Colors.green,
                                    inactiveTrackColor: Colors.white,
                                    activeColor: Colors.red,
                                    onChanged: (bool value) {
                                      DataStore.me.active =
                                          viewModel.activeStatus;
                                      if (value == true)
                                        askForLocationPermissionIfDisabled();
                                      if (value == false)
                                        print(DataStore.token);
                                      _bloc.fire(HomeEvents
                                          .getDocumentVerificationStatus);
                                      _bloc.fire(HomeEvents.activityStatusSet,
                                          message: {'status': value},
                                          onHandled: (e, m) {
                                        _BEENAME.put("myActiveStatus",
                                            value ? "true" : "false");
                                        widget.onSwitchChangedState(
                                            m.activeStatus);
                                        if (m.activeStatus) {}
                                      });
                                    },
                                  );
                                },
                              )
                            : SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
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
                (_BEENAME.get("myDocumentVerification") == "true" &&
                        _BEENAME.get("myActiveStatus") == "true")
                    ? Expanded(child: mapWidget)
                    : SizedBox(),
                (_BEENAME.get("myActiveStatus") == "false")
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("You are not an active Bee! ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                PrimaryColors.backgroundColor,
                                            fontWeight: FontWeight.w500)),
                                    Icon(
                                      Icons.sentiment_dissatisfied,
                                      color: Colors.deepPurple,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Switch on the button above for a fly.",
                                    style: TextStyle(
                                        color: PrimaryColors.backgroundColor,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                (_BEENAME.get("myDocumentVerification") == "false" &&
                        _BEENAME.get("myActiveStatus") == "true")
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("It seems you are active but...",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                PrimaryColors.backgroundColor,
                                            fontWeight: FontWeight.w500)),
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
                                        color: PrimaryColors.backgroundColor,
                                        fontWeight: FontWeight.w500)),
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
                                  color: PrimaryColors.backgroundColor),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
