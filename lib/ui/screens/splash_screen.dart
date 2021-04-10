import 'package:fixbee_partner/blocs/splash_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/splash_model.dart';
import 'package:fixbee_partner/ui/custom_widget/no_internet_widget.dart';
import 'package:fixbee_partner/ui/custom_widget/splash_widget.dart';
import 'package:fixbee_partner/ui/screens/all_service_selection_screen.dart';
import 'package:fixbee_partner/ui/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  SplashBloc _bloc;
  bool onLaunch = false;
  bool hideIcon = false;
  Box _BEENAME;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  _openHive() async {
    await Hive.openBox<String>("BEE");
    _BEENAME = Hive.box<String>("BEE");
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      DataStore.appBuildNumber = info.buildNumber.toString();
      DataStore.appVersion = info.version.toString();
    });
  }

  void cacheMetaData(metaData) {
    _BEENAME.put('appVersion', _packageInfo.version.toString());
    _BEENAME.put('helpline', metaData.helpline);
    _BEENAME.put(
        'minWalletAmount', metaData.minimumWalletAmount.toString() ?? '');
    _BEENAME.put(
        'minWalletDeposit', metaData.minimumWalletDeposit.toString() ?? '');
    String officeTimings = concatenatedString(metaData.officeTimings);
    _BEENAME.put('officeTimings', officeTimings);
    _BEENAME.put('helpEmail', metaData.email);
  }

  concatenatedString(List<String> str) {
    String cs = '';
    str.forEach((element) {
      cs = cs + element + ',';
    });
    return cs;
  }

  void refreshAllData(Bee bee) {
    _BEENAME.put("myPhone", bee.phoneNumber);
    _BEENAME.put("firstName", bee.firstName);
    _BEENAME.put("middleName", bee.middleName);
    _BEENAME.put("lastName", bee.lastName);
    _BEENAME.put(
        ("myName"), getMyName(bee.firstName, bee.middleName, bee.lastName));
    _BEENAME.put("myDocumentVerification", (bee.verified) ? "true" : "false");
    _BEENAME.put("dpUrl", bee.dpUrl);
    _BEENAME.put("myActiveStatus", (bee.active) ? "true" : "false");
    _BEENAME.put('myRating', bee.myRating.toString());
    _BEENAME.put("myWallet", bee.walletAmount.toString());
  }

  void putIntoHive(Bee bee) {
    _BEENAME.put("myPhone", bee.phoneNumber);
    _BEENAME.put("firstName", bee.firstName);
    _BEENAME.put("middleName", bee.middleName);
    _BEENAME.put("lastName", bee.lastName);
    _BEENAME.put(
        ("myName"), getMyName(bee.firstName, bee.middleName, bee.lastName));
    _BEENAME.put("myDocumentVerification", (bee.verified) ? "true" : "false");
    _BEENAME.put("dpUrl", bee.dpUrl);
    _BEENAME.put('myRating', bee.myRating.toString());
    _BEENAME.put("myActiveStatus", (bee.active) ? "true" : "false");
    _BEENAME.put("myWallet", bee.walletAmount.toString());
  }

  @override
  void initState() {
    _initPackageInfo();
    _openHive();
    _bloc = SplashBloc(SplashModel());
    _bloc.fire(Event(100), onHandled: (e, m) async {
      setupSplash(m);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return (viewModel.connection)
              ? SplashWidget(
                  currentAppVersion: _packageInfo.version.toString(),
                )
              : NoInternetWidget(
                  retryConnecting: () {
                    _bloc.fire(Event(100), onHandled: (e, m) {
                      setupSplash(m);
                    });
                  },
                  loading: _bloc.latestViewModel.tryReconnecting,
                );
        }),
      ),
    );
  }

  setupSplash(var m) {
    if (m.connection) {
      if (!m.metadata.available) {
        _showServerUnderMaintenanceDialog();
      } else if (m.metadata.criticalUpdate &&
          m.metadata.buildNumber > int.parse(_packageInfo.buildNumber)) {
        _showUpdateDialog();
      } else {
        if (m.tokenFound) {
          if (m.hasError) {
            _showMessageDialog(m.errorMessage);
          } else {
            if (_BEENAME.containsKey('myPhone') ||
                _BEENAME.containsKey('myPhone') != null) {
              if (m.me.phoneNumber != _BEENAME.get('myPhone'))
                refreshAllData(m.me);
              else
                putIntoHive(m.me);
            }
            if (m?.me?.services == null || m.me.services.length == 0) {
              try {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: AllServiceSelection()));
              } catch (e) {}
            } else {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: NavigationScreen(
                        currentAppBuildNumber:
                            int.parse(_packageInfo.buildNumber),
                      )));
            }
          }
        } else
          Navigator.pushReplacement(context,
              PageTransition(type: PageTransitionType.fade, child: Login()));
      }
    }
  }

  _showMessageDialog(message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: PrimaryColors.backgroundColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          );
        });
  }

  _showServerUnderMaintenanceDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: PrimaryColors.backgroundColor,
            content: Container(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text:
                            'Bee we\'ve got something special in store for you.',
                        style: TextStyle(
                          color: PrimaryColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: '\n\nPlease check again later!',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ]),
                  )),
            ),
          );
        });
  }

  _showUpdateDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: PrimaryColors.backgroundColor,
            content: Text(
              'Critical Update Available!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              RaisedButton(
                elevation: 4,
                color: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                onPressed: () {
                  _launchURL(Constants.PLAYSTORE_APP_LINK);
                },
                child: Text('Update'),
              )
            ],
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
