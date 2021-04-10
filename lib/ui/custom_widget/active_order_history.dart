import 'package:fixbee_partner/utils/colors.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class ActiveOrderHistory extends StatefulWidget {
  final String userName, serviceName, status;
  final String timeStamp;
  final Function seeMore;

  const ActiveOrderHistory(
      {Key key,
      this.serviceName,
      this.status,
      this.timeStamp,
      this.seeMore,
      this.userName})
      : super(key: key);
  @override
  _ActiveOrderHistoryState createState() => _ActiveOrderHistoryState();
}

class _ActiveOrderHistoryState extends State<ActiveOrderHistory> {
  DateTimeFormatter dtf = DateTimeFormatter();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(
                          "User : " + widget.userName.toUpperCase(),
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(

                        children: [
                          Expanded(
                            child: Container(

                              child: Text(
                                "Service : " + widget.serviceName,
                                maxLines: null,
                                style: TextStyle(
                                    color: Colors.tealAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                                color: FixbeeColors.kCardColorLighter,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              widget.status.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (widget.status.toUpperCase() ==
                                          'ASSIGNED')
                                      ? Theme.of(context).errorColor
                                      : Theme.of(context).accentColor,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                      child: Divider(
                        color: Colors.tealAccent,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Row(
                        children: [
                          InkWell(
                            child: GestureDetector(
                              onTap: widget.seeMore,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4),
                                  child: Text(
                                    "Launch",
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                    color: FixbeeColors.kCardColorLighter,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(dtf.getDate(widget.timeStamp))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                    color: FixbeeColors.kCardColorLighter,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(dtf.getTime(widget.timeStamp))),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
