import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  closeHiveBox() async {
    await Hive.close();
    await Hive.deleteBoxFromDisk("BEE");
  }

  @override
  void initState() {
    Route route =
    MaterialPageRoute(builder: (context) => SplashScreen());
    Navigator.push(context, route);
    super.initState();
  }
  @override
  void dispose() {
    closeHiveBox();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
