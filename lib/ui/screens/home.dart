import 'package:fixbee_partner/blocs/home_bloc.dart';
import 'package:fixbee_partner/events/home_events.dart';
import 'package:fixbee_partner/models/home_model.dart';
import 'package:fixbee_partner/ui/custom_widget/job_notification.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc _bloc;
  GoogleMapController mapController;
  GoogleMap mapWidget;
  Set<Marker> markers = Set();
  Geolocator geoLocator = Geolocator();
  static const tenSec = const Duration(seconds: 10);
  double latitude;
  double longitude;



  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc(HomeModel());
    _bloc.fire(HomeEvents.activityStatusRequested, onHandled: (e, m) {
      if (m.activeStatus) {
        _bloc.subscribeToNotifications();
        new Timer.periodic(
            tenSec,
            (Timer t) => _getLocation().then((value) {
                  print(value.latitude);
                  print(value.longitude);
                  latitude = value.latitude;
                  longitude = value.longitude;
                  _bloc.fire(HomeEvents.updateLiveLocation, message: {
                    'latitude': value.latitude,
                    'longitude': value.longitude
                  });
                }));

      }
    });
    super.initState();
  // set customer location
    var marker = Marker(
        markerId: MarkerId("Your Location"),
        position: LatLng(latitude ?? 23.829321, longitude ?? 91.277847));
    markers.add(marker);
    mapWidget = GoogleMap(
      markers: markers,
      onMapCreated: (GoogleMapController googleMapController) {
        mapController = googleMapController;
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(latitude ?? 23.829321, longitude ?? 91.277847),
          zoom: 18),
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
                      color: Colors.amber,
                      boxShadow: [BoxShadow(color: Colors.brown)]),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: new Container(),
                        flex: 2,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Set Your Activity Status",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ),
                        flex: 25,
                      ),
                      Flexible(
                        child: new Container(),
                        flex: 8,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: !viewModel.loading
                              ? Switch(
                                  value: viewModel.activeStatus,
                                  inactiveThumbColor: Colors.brown[300],
                                  inactiveTrackColor: Colors.white,
                                  activeColor: Colors.brown,
                                  onChanged: (bool value) {
                                    _bloc.fire(HomeEvents.activityStatusSet,
                                        message: {'status': value},
                                        onHandled: (e, m) {
                                      if (m.activeStatus) {
                                        _bloc.subscribeToNotifications();
                                      } else {
                                        _bloc.unSubscribe();
                                      }
                                    });
                                  },
                                )
                              : SizedBox(
                                  child: CircularProgressIndicator(),
                                  height: 30,
                                  width: 30,
                                ),
                        ),
                        flex: 11,
                      )
                    ],
                  ),
                ),
                viewModel.activeStatus
                    ? Expanded(child: mapWidget)
                    : Column(
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height/3,),
                        Center(
                            child: Text("You are not eligible to aquire jobs",
                                style: TextStyle(color: Colors.brown)),
                          ),
                      ],
                    ),
                viewModel.activeStatus ? JobNotification() : Container(),

                //model.activeStatus ?  updateLocation() : Container();
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
