import 'package:flutter/material.dart';


class AvailableAccounts extends StatefulWidget {
 final  String accountHoldersName, ifsc, accountNumber;
 final bool verified;

  const AvailableAccounts({Key key, this.accountHoldersName, this.ifsc, this.accountNumber, this.verified}) : super(key: key);


  @override
  _AvailableAccountsState createState() => _AvailableAccountsState();
}

class _AvailableAccountsState extends State<AvailableAccounts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
      child: Card(
        child: Wrap(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                        child: Text(
                          "Account Holder's Name:",
                          maxLines: null,
                          style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ),
                      widget.verified?Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                        child: Icon(Icons.check_box, color: Colors.blue,),
                      ):SizedBox(),

                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Text(
                        widget.accountHoldersName,
                        maxLines: null,
                        //textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: Text(
                      "Account Number:",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Container(

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Text(
                        widget.accountNumber,
                        maxLines: null,
                        //textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

