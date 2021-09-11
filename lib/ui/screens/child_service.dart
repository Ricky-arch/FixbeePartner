import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/models/all_Service.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/utils/colors.dart';
import 'package:fixbee_partner/utils/excerpt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';
import '../../data_store.dart';

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
        body: FutureBuilder<AllService>(
            future: widget.childServices,
            builder: (context, snapshot) {
              return (!snapshot.hasData)
                  ? Center(child: CustomCircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 30),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: (widget.imageUrl == null)
                                    ? Image.asset(
                                        "assets/logo/new_launcher_icon.png")
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: widget.imageUrl,
                                        httpHeaders: {
                                          'authorization': DataStore.token
                                        },
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Skills related to: ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                      TextSpan(
                                        text: "${widget.title}",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        (snapshot.data.childServices.length == 0)
                            ? Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No items available!  ",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.sentiment_dissatisfied_rounded,
                                        color: Theme.of(context).errorColor,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data.childServices.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var excerpt = snapshot
                                        .data.childServices[index].excerpt;
                                    bool checkBoxValue = snapshot
                                        .data.childServices[index].selected;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 85,
                                                width: 85,
                                                decoration: BoxDecoration(
                                                    color: FixbeeColors
                                                        .kImageBackGroundColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                                  child: (snapshot
                                                              .data
                                                              .childServices[
                                                                  index]
                                                              .imageLink ==
                                                          null)
                                                      ? Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            image:
                                                                DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image:
                                                                        AssetImage(
                                                                      "assets/logo/new_launcher_icon.png",
                                                                    )),
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: snapshot
                                                              .data
                                                              .childServices[
                                                                  index]
                                                              .imageLink,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                          httpHeaders: {
                                                            'authorization':
                                                                DataStore.token
                                                          },
                                                        ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                          snapshot
                                                              .data
                                                              .childServices[
                                                                  index]
                                                              .serviceName
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    _footer(excerpt)
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(width:50),

                                              Checkbox(
                                                checkColor: Theme.of(context)
                                                    .accentColor,
                                                activeColor:
                                                    Theme.of(context).cardColor,
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
                                    );
                                  },
                                ),
                              ),
                      ],
                    );
            }),
      ),
    );
  }

  Widget excerptField(String excerpt) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: Theme.of(context).hintColor,
          size: 5,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              excerpt ?? "",
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(Excerpt excerpt) {
    if (excerpt.bulletPoints != null && excerpt.bulletPoints.isNotEmpty)
      return Column(
        children: excerpt.bulletPoints.map((e) {
          return excerptField(e);
        }).toList(),
      );
    else if (excerpt.text != null && excerpt.text.isNotEmpty)
      return excerptField(excerpt.text);
    else if (excerpt.rawString != null && excerpt.rawString.isNotEmpty)
      return excerptField(excerpt.rawString);
    else
      return SizedBox();
  }
}
