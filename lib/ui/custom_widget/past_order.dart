import 'package:flutter/material.dart';

import '../../Constants.dart';

class PastOrder extends StatefulWidget {
  final String userName, serviceName, status;
  final int amount;
  final String timeStamp;
  final Function seeMore;

  const PastOrder(
      {Key key,
      this.userName,
      this.serviceName,
      this.amount,
      this.status,
      this.timeStamp,
      this.seeMore})
      : super(key: key);
  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.serviceName +
                                " \u20B9 ${(widget.amount) / 100}",
                            style: TextStyle(
                                color: PrimaryColors.backgroundColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.tealAccent),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.status,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
//                    Padding(
//                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
//                      child: Text(
//                        widget.userName,
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, fontSize: 12),
//                      ),
//                    ),
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
                                color: Colors.yellow.withOpacity(.5),
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
                            child: Text(widget.timeStamp),
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
