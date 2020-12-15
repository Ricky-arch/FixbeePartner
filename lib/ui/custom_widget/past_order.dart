import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class PastOrder extends StatefulWidget {
  final String userName, serviceName, status;
  final int amount;
  final String timeStamp;
  final Function seeMore;
  final List<Service> addOns;
  final Color backGroundColor;
  final bool loading;

  const PastOrder(
      {Key key,
      this.userName,
      this.serviceName,
      this.amount,
      this.status,
      this.timeStamp,
      this.seeMore,
      this.addOns,
      this.backGroundColor,
      this.loading})
      : super(key: key);
  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  DateTimeFormatter dtf = DateTimeFormatter();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: (widget.status.toString() != 'CANCELLED')
                    ? widget.backGroundColor
                    : Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.tealAccent)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: Text(
                            widget.serviceName +
                                " \u20B9 ${widget.amount / 100}",
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: (widget.loading)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: PrimaryColors.backgroundColor,
                            ),
                          )
                        : Divider(
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
                                color: (widget.status.toString() != 'CANCELLED')
                                    ? Colors.orangeAccent.withOpacity(.9)
                                    : Colors.grey.withOpacity(.9),
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
                                  "SEE MORE",
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
                        SizedBox(
                          width: 10,
                        ),
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
    );
  }
}
