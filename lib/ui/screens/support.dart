import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants.dart';
import '../../data_store.dart';
import 'about.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Our  ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        TextSpan(
                          text: "Support",
                          style: TextStyle(
                              fontSize: 26,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

                address(), officeTimings(), call(), email(), about()],
            ),
          ),
        ));
  }

  Widget about() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'ABOUT',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return About();
                    }));
                  },
                  child: Icon(
                    Icons.arrow_right,
                    color: Theme.of(context).accentColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
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

  Widget address() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).accentColor,
                  size: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'ABOUT',
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
                Constants.FIXBEE_ADDRESS,
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

  Widget officeTimings() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  color: Theme.of(context).accentColor,
                  size: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'OFFICE TIMINGS',
                  style:
                      TextStyle(color: Theme.of(context).accentColor, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: DataStore.metaData.officeTimings.length,
                    itemBuilder: (ctx, int index) {
                      return Text(
                        DataStore.metaData.officeTimings[index],
                        style: TextStyle(
                            color: Theme.of(context).accentColor.withOpacity(.7)),
                      );
                    })),
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

  Widget call() {
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
                          Icons.call,
                          color: Theme.of(context).accentColor,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'CALL US?',
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
                        '+91-' + DataStore.metaData.helpline,
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
                      Icons.call,
                      size: 30,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      launch("tel://+91${DataStore.metaData.helpline}");
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

  Widget email() {
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
                          Icons.email_outlined,
                          color: Theme.of(context).accentColor,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'EMAIL US?',
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
                        DataStore.metaData.email,
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
                      Icons.email,
                      size: 30,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      launch(
                          "mailto:${DataStore.metaData.email}?subject=Request Support For Bee.\nRegistered Phone No: ${DataStore.me.phoneNumber}");
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
}
