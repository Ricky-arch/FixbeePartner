import 'package:fixbee_partner/ui/screens/licenses.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants.dart';
import '../../data_store.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "About  ",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                    ),
                    TextSpan(
                      text: "Us",
                      style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            appData('APP VERSION', DataStore.appVersion),
            appData('BUILD NUMBER', DataStore.appBuildNumber),
            libraries(context),
          ],
      ),
    ),
        ));
  }

  Widget appData(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).accentColor,
                  size: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                  style:
                      TextStyle(color: Theme.of(context).accentColor, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                value,
                style:
                    TextStyle(color: Theme.of(context).accentColor.withOpacity(.7)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 3,
              color: Theme.of(context).accentColor.withOpacity(.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget libraries(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'ALL LIBRARIES',
                          style: TextStyle(
                              color: Theme.of(context).accentColor, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'View licenses',
                        style: TextStyle(
                            color: Theme.of(context).accentColor.withOpacity(.7)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                IconButton(
                    icon: Icon(
                      Icons.arrow_right,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showLicensePage(
                        context: context,
                        applicationIcon: applicationIcon()
                      );
                    })
              ],
            ),
            Divider(
              height: 3,
              color: Theme.of(context).accentColor.withOpacity(.3),
            ),
          ],
        ),
      ),
    );
  }

  void showLicensePage({
    BuildContext context,
    String applicationName,
    String applicationVersion,
    Widget applicationIcon,
    String applicationLegalese,
    bool useRootNavigator = false,
  }) {
    assert(context != null);
    assert(useRootNavigator != null);
    Navigator.of(context, rootNavigator: useRootNavigator)
        .push(MaterialPageRoute<void>(
      builder: (BuildContext context) => LicensePage(
        applicationName: applicationName,
        applicationVersion: applicationVersion,
        applicationIcon: applicationIcon,
        applicationLegalese: applicationLegalese,
      ),
    ));
  }

  Widget applicationIcon() {
    return Center(
        child: Image.asset(
      "assets/logo/splash_logo.png",
      width: MediaQuery.of(context).size.width / 4,
      //height: MediaQuery.of(context).size.height / 2,
    ));
  }
}
