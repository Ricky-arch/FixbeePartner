import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/models/all_Service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class ChildService extends StatefulWidget {
  final Future<AllService> childServices;
  final String title, imageUrl;

  const ChildService({Key key, this.childServices, this.title, this.imageUrl})
      : super(key: key);
  @override
  _ChildServiceState createState() => _ChildServiceState();
}

class _ChildServiceState extends State<ChildService> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PrimaryColors.backgroundcolorlight,
        appBar: AppBar(
          backgroundColor: PrimaryColors.backgroundColor,
          automaticallyImplyLeading: false,
          title: Stack(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(color: PrimaryColors.backgroundColor),
                  child: Row(
                    children: [
                      Container(
                        height: 45,
                        width: 50,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: (widget.imageUrl == null)
                            ? Image.asset("assets/logo/new_launcher_icon.png")
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.imageUrl,
                              ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        body: FutureBuilder<AllService>(
            future: widget.childServices,
            builder: (context, snapshot) {
              return (!snapshot.hasData)
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.childServices.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool checkBoxValue =
                                  snapshot.data.childServices[index].selected;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                              color: Colors.tealAccent)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 12),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 75,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8),
                                              child: (snapshot
                                                          .data
                                                          .childServices[index]
                                                          .imageLink ==
                                                      null)
                                                  ? Image.asset(
                                                      "assets/logo/new_launcher_icon.png")
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: snapshot
                                                          .data
                                                          .childServices[index]
                                                          .imageLink,
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Text(
                                                snapshot
                                                    .data
                                                    .childServices[index]
                                                    .serviceName,
                                                style: TextStyle(
                                                    color: PrimaryColors
                                                        .backgroundColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Spacer(),
                                            Checkbox(
                                              value: checkBoxValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value)
                                                    snapshot
                                                        .data.selectedServices
                                                        .add(snapshot.data
                                                                .childServices[
                                                            index]);
                                                  else
                                                    snapshot
                                                        .data.selectedServices
                                                        .remove(snapshot.data
                                                                .childServices[
                                                            index]);
                                                  snapshot
                                                      .data
                                                      .childServices[index]
                                                      .selected = value;
                                                  checkBoxValue = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
