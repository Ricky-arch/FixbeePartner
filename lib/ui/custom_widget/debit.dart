import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';

class Debit extends StatefulWidget {
  final int amount;
  final String timeStamp;
  final Function seeMore;
  final bool onOrderDebit;

  const Debit({Key key, this.amount, this.seeMore, this.timeStamp, this.onOrderDebit})
      : super(key: key);
  @override
  _DebitState createState() => _DebitState();

}

class _DebitState extends State<Debit> {
  DateTimeFormatter dtf = DateTimeFormatter();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            color: PrimaryColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: (widget.onOrderDebit)?Colors.tealAccent:Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "Your wallet has been debited by:  ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: PrimaryColors.backgroundColor),
                  ),
                  TextSpan(
                    text: Constants.rupeeSign +
                        (widget.amount / 100).toStringAsFixed(2),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (widget.onOrderDebit)?Colors.black:Colors.blue,
                        fontSize: 20),
                  )
                ]),
              ),
              Divider(
                color: Colors.tealAccent,
                thickness: 1,
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
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "SEE MORE",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
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
    );
  }
}
