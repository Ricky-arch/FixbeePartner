import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class ActiveOrderHistory extends StatefulWidget {
  final String orderId, serviceName, status;
  final String timeStamp;
  final Function seeMore;

  const ActiveOrderHistory(
      {Key key,
      this.serviceName,
      this.status,
      this.timeStamp,
      this.seeMore,
      this.orderId})
      : super(key: key);
  @override
  _ActiveOrderHistoryState createState() => _ActiveOrderHistoryState();
}

class _ActiveOrderHistoryState extends State<ActiveOrderHistory> {
  DateTimeFormatter dtf= DateTimeFormatter();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.tealAccent)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(
                          widget.orderId.toUpperCase(),
                          style: TextStyle(color: Colors.black, fontSize: 16,  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: Text(
                              widget.serviceName,
                              maxLines: null,
                              style: TextStyle(
                                  color: PrimaryColors.backgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.tealAccent),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.status,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
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
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.orangeAccent.withOpacity(.9),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "LAUNCH",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(dtf.getDate(widget.timeStamp)),
                          ),
                          SizedBox(width: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(dtf.getTime(widget.timeStamp)),
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
