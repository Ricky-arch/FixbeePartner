import 'package:fixbee_partner/ui/custom_widget/custom_button_type_3.dart';
import 'package:flutter/material.dart';

import 'available_accounts.dart';

class FundAccountWidget extends StatefulWidget {
  final bool isBankAccount;
  final list;


  const FundAccountWidget({Key key, this.isBankAccount, this.list})
      : super(key: key);
  @override
  _FundAccountWidgetState createState() => _FundAccountWidgetState();
}

class _FundAccountWidgetState extends State<FundAccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: widget.list.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    (widget.isBankAccount)
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Account ${index + 1}:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                            ],
                          )
                        : SizedBox(),
                    (!widget.isBankAccount)
                        ? SizedBox(
                            height: 10,
                          )
                        : SizedBox(),
                    (widget.isBankAccount)
                        ? AvailableAccounts(
                            isBankAccount: widget.isBankAccount,
                            accountHoldersName:
                                widget.list[index].accountHoldersName,
                            accountNumber: widget.list[index].bankAccountNumber,
                          )
                        : AvailableAccounts(
                            isBankAccount: widget.isBankAccount,
                            addressIndex: index + 1,
                            accountHoldersName: widget.list[index].address,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    // CustomButtonType3(
                    //   isBankAccount: widget.isBankAccount,
                    //   doSomething: widget.doSomething,
                    // ),
                  ],
                );
              }))
    ]);
  }
}
