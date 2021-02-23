import 'package:flutter/material.dart';

class AvailableAccounts extends StatefulWidget {
  final String accountHoldersName, ifsc, accountNumber;
  final bool isBankAccount;
  final bool verified;
  final int addressIndex;

  const AvailableAccounts(
      {Key key,
      this.accountHoldersName,
      this.ifsc,
      this.accountNumber,
      this.verified = false,
      this.isBankAccount,
      this.addressIndex})
      : super(key: key);

  @override
  _AvailableAccountsState createState() => _AvailableAccountsState();
}

class _AvailableAccountsState extends State<AvailableAccounts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
      child: Card(
        elevation: 5,
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
                        padding: EdgeInsets.fromLTRB(
                            10,
                            (!widget.isBankAccount) ? 12 : 8,
                            8,
                            (!widget.isBankAccount) ? 12 : 8),
                        child: Text(
                          (widget.isBankAccount)
                              ? "Account Holder's Name:"
                              : "Address ${widget.addressIndex}:",
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ),
                      widget.verified
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                              child: Icon(
                                Icons.check_box,
                                color: Colors.blue,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Text(
                          widget.accountHoldersName,
                          overflow: TextOverflow.ellipsis,
                          //textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              (widget.isBankAccount)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                          child: Text(
                            "Account Number:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
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
                    )
                  : SizedBox(),
            ],
          ),
        ]),
      ),
    );
  }
}
