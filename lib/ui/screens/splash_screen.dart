import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/animations/faded_animations.dart';
import 'package:fixbee_partner/blocs/splash_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/splash_model.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:fixbee_partner/ui/screens/service_selection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  SplashBloc _bloc;
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  bool hideIcon = false;
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _bloc = SplashBloc(SplashModel());
    _bloc.fire(Event(100), onHandled: (e, m) {
      if (m.tokenFound) {
        if (m.me.services.length == 0)
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: ServiceSelectionScreen()));
        else {
          _getCurrentLocation();
          if (_currentPosition != null)
            DataStore.beePosition = _currentPosition;
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: NavigationScreen()));
        }
      } else
        Navigator.push(context,
            PageTransition(type: PageTransitionType.fade, child: Login()));
    });
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _positionController.forward();
            }
          });

    _positionController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              _scale2Controller.forward();
            }
          });

    _scale2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _scale2Animation = Tween<double>(begin: 1.0, end: 32.0).animate(
        _scale2Controller)
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          if (_bloc.latestViewModel.tokenFound)
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: ServiceSelectionScreen()));
          else
            Navigator.push(context,
                PageTransition(type: PageTransitionType.fade, child: Login()));
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.extinguish();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: PrimaryColors.backgroundColor,
      body: SafeArea(
        child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return Container(
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -50,
                  left: 0,
                  child: FadeAnimation(
                      1,
                      Container(
                        width: width,
                        height: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/one.png'),
                                fit: BoxFit.cover)),
                      )),
                ),
                Positioned(
                  top: -100,
                  left: 0,
                  child: FadeAnimation(
                      1.3,
                      Container(
                        width: width,
                        height: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/one.png'),
                                fit: BoxFit.cover)),
                      )),
                ),
                Positioned(
                  top: -150,
                  left: 0,
                  child: FadeAnimation(
                      1.3,
                      Container(
                        width: width,
                        height: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/one.png'),
                                fit: BoxFit.cover)),
                      )),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/custom_icons/bee.png",
                                height: 70,
                              ),
                            )),
                        SizedBox(height: 20),
                        FadeAnimation(
                            1,
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Fixbee ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 30)),
                                  TextSpan(
                                    text: 'Partner',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow,
                                        fontSize: 30),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        FadeAnimation(
                            1.3,
                            Text(
                              "We provide Optimal Services!",
                              style: TextStyle(
                                  color: Colors.white,
                                  height: 1.4,
                                  fontSize: 18),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                            1.6,
                            AnimatedBuilder(
                              animation: _scaleController,
                              builder: (context, child) => Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: Center(
                                    child: AnimatedBuilder(
                                      animation: _widthController,
                                      builder: (context, child) => Container(
                                        width: _widthAnimation.value,
                                        height: 80,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color:
                                                Colors.white.withOpacity(.4)),
                                        child: InkWell(
                                          onTap: () {
                                            _scaleController.forward();
                                          },
                                          child: Stack(children: <Widget>[
                                            AnimatedBuilder(
                                              animation: _positionController,
                                              builder: (context, child) =>
                                                  Positioned(
                                                left: _positionAnimation.value,
                                                child: AnimatedBuilder(
                                                  animation: _scale2Controller,
                                                  builder: (context, child) =>
                                                      Transform.scale(
                                                          scale:
                                                              _scale2Animation
                                                                  .value,
                                                          child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                            child: hideIcon ==
                                                                    false
                                                                ? Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                : Container(),
                                                          )),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  )),
                            )),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
