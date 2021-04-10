import 'package:fixbee_partner/models/navigation_model.dart';
import 'package:fixbee_partner/utils/colors.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class PastOrder extends StatefulWidget {
  final String userName, serviceName, status;
  final String orderId;
  final int amount;
  final bool cashOnDelivery;
  final String timeStamp;
  final Function(String, bool) seeMore;
  final List<Service> addOns;
  final Color backGroundColor;
  final bool loading;

  const PastOrder({
    Key key,
    this.userName,
    this.serviceName,
    this.amount,
    this.status,
    this.timeStamp,
    this.seeMore,
    this.addOns,
    this.backGroundColor,
    this.loading,
    this.orderId,
    this.cashOnDelivery,
  }) : super(key: key);
  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  DateTimeFormatter dtf;
  @override
  void initState() {
    dtf = DateTimeFormatter.parse(widget.timeStamp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: (widget.status.toString() != 'cancelled')
                  ? widget.backGroundColor
                  : Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          child: Expanded(
                            child: Text(
                              widget.serviceName,
                              maxLines: null,
                              style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: FixbeeColors.kCardColorLighter,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            widget.status.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    (widget.status.toUpperCase() == 'ASSIGNED')
                                        ? Theme.of(context).errorColor
                                        : Theme.of(context).accentColor,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                    child: Divider(
                      color: Theme.of(context).hintColor,
                      thickness: .5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Row(
                      children: [
                        InkWell(
                          child: GestureDetector(
                            onTap: () {
                              widget.seeMore(
                                  widget.orderId, widget.cashOnDelivery);
                            },
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SEE MORE",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).canvasColor,
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
                              child: Text(dtf.formattedDate)),
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
                              child: Text(dtf.formattedTime)),
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
