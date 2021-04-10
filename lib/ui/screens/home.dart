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
import 'package:url_launcher/url_launcher.dart';

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

  _updateHive(bool status) {
    _BEENAME.put("myDocumentVerification", status.toString());
  }

  Future<bool> askForLocationPermissionIfDisabled() async {
    if (!await GeolocatorPlatform.instance.isLocationServiceEnabled())
      GeolocatorPlatform.instance.requestPermission();
    return true;
  }

  bool dialog = false;

  @override
  void initState() {
    _openHive();
    super.initState();
    askForLocationPermissionIfDisabled();
    _bloc = HomeBloc(HomeModel());
    _bloc.onSwitchChange = widget.onSwitchChangedState;
    _bloc.fire(HomeEvents.getDocumentVerificationStatus, onHandled: (e, m) {
      _updateHive(m.verifiedBee);
    });
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
      body: SafeArea(
        child: _bloc.widget(
          onViewModelUpdated: (ctx, viewModel) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: PrimaryColors.backgroundColor,
                      boxShadow: [BoxShadow(color: Colors.brown)]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 12, 12, 12),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Your  ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                TextSpan(
                                  text: "Activity Status",
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                      _bloc.fire(
                                          HomeEvents
                                              .getDocumentVerificationStatus,
                                          onHandled: (e, m) {
                                        _BEENAME.put('myDocumentVerification',
                                            m.verifiedBee.toString());
                                      });
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
                ValueListenableBuilder(
                  valueListenable: _BEENAME.listenable(),
                  builder: (context, box, _) {
                    print(_BEENAME.get("myDocumentVerification"));
                    return Container();
                  },
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
                                    Text("You are not an active Bee!  ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.normal)),
                                    Icon(
                                      Icons.sentiment_dissatisfied_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Switch on the button above for a fly.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.normal)),
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
                                            fontSize: 20,
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.normal)),
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
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
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
                                  color: Theme.of(context).canvasColor),
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
