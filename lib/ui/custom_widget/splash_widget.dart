import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashWidget extends StatefulWidget {
  final bool hasCriticalUpdate;
  final String currentAppVersion;
  final bool serverUnderMaintenance;

  const SplashWidget(
      {Key key,
      this.hasCriticalUpdate,
      this.currentAppVersion,
      this.serverUnderMaintenance=false})
      : super(key: key);
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: Container(
                child: Image.asset(
              "assets/logo/splash_logo.png",
              width: MediaQuery.of(context).size.width / 2,
              //height: MediaQuery.of(context).size.height / 2,
            )
            ),
          ),


          Spacer(),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Made with ❤️ for Tripura',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'V : ' + widget.currentAppVersion,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
