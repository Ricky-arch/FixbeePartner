import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/bank_details_bloc.dart';
import 'package:fixbee_partner/events/bank_details_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
import 'package:fixbee_partner/ui/custom_widget/available_accounts.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class TransactionAccount extends StatefulWidget {
  @override
  _TransactionAccountState createState() => _TransactionAccountState();
}

class _TransactionAccountState extends State<TransactionAccount> {
  BankDetailsBloc _bloc;
  TextEditingController _bankAccountNumber = TextEditingController();
  TextEditingController _ifscCode = TextEditingController();
  TextEditingController _accountHoldersName = TextEditingController();
  TextEditingController _vpaController = TextEditingController();
  final _bankKey = GlobalKey<FormState>();
  final _vpaKey = GlobalKey<FormState>();
  bool _bankValidate = false;
  bool _vpaValidate = false;

  @override
  void initState() {
    _bloc = BankDetailsBloc(BankDetailsModel());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
//               pinned: true,
//                floating: false,
                  titleSpacing: 0,
                  backgroundColor: PrimaryColors.backgroundColor,
                  elevation: 3,
                  title: Container(
                    height: 32,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 12, 12, 0),
                      child: Text(
                        "Your Transaction Accounts",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(48),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(horizontal: 10),
                          indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.white,
                              ),
                              insets: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5)),
                          tabs: [
                            Tab(
                              child: Text(
                                'BANK-ACCOUNTS',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'VPA',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: FutureBuilder<BankDetailsModel>(
                    future: _bloc.fetchAllAccounts(),
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData)
                        return TabBarView(children: [
                          Tab(
                              child: Center(
                            child: CircularProgressIndicator(),
                          )),
                          Tab(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ))
                        ]);
                      else {
                        return TabBarView(
                          children: [
                            Tab(
                              child: Scaffold(
                                body: (snapshot.data.bankAccountList.length != 0)
                                    ? ListView(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount: snapshot
                                                  .data.bankAccountList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            "Account ${index + 1}:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                    AvailableAccounts(
                                                      isBankAccount: true,
                                                      accountHoldersName: snapshot
                                                          .data
                                                          .bankAccountList[
                                                              index]
                                                          .accountHoldersName,
                                                      accountNumber: snapshot
                                                          .data
                                                          .bankAccountList[
                                                              index]
                                                          .bankAccountNumber,
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ],
                                      )
                                    : Text('No Bank Accounts Added',
                                        style: TextStyle(color: Colors.black)),
                                floatingActionButton: FloatingActionButton(
                                  mini: true,
                                  elevation: 0,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _newBankAccountForm(context);
                                  },
                                ),
                              ),
                            ),
                            Tab(
                              child: Scaffold(
                                body: (snapshot.data.vpaList.length != 0)
                                    ? ListView(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  snapshot.data.vpaList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    AvailableAccounts(
                                                      isBankAccount: false,
                                                      addressIndex: index + 1,
                                                      accountHoldersName:
                                                          snapshot
                                                              .data
                                                              .vpaList[index]
                                                              .address,
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ],
                                      )
                                    : Text('No Vpa Accounts Added',
                                        style: TextStyle(color: Colors.black)),
                                floatingActionButton: FloatingActionButton(
                                  mini: true,
                                  elevation: 0,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _newVpaAddressForm(context);
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _newBankAccountForm(context) {
    showModalBottomSheet(
        backgroundColor: PrimaryColors.backgroundcolorlight,
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                (_bloc.latestViewModel.addingAccount)
                    ? LinearProgressIndicator()
                    : SizedBox(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 8),
                          child: Text(
                            "Fill your bank details",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Form(
                        key: _bankKey,
                        autovalidate: _bankValidate,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: _bankAccountNumber,
                                validator: (value) {
                                  if (!isNumeric(value.trim())) {
                                    return 'Please Enter Your Bank Account Number';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Bank Account Number",
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: _ifscCode,
                                validator: (value) {
                                  if (!isAlphanumeric(value.trim())) {
                                    return 'Please Enter Your Bank IfSC Code';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  labelText: "IFSC Code",
                                  labelStyle: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: _accountHoldersName,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please Enter Your Bank Account Holders Name';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  labelText: "Bank Account Holders Name",
                                  labelStyle: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                textColor: Colors.yellow,
                                color: PrimaryColors.backgroundColor,
                                onPressed: () {
                                  if (_bankKey.currentState.validate()) {
                                    _bloc.fire(
                                      BankDetailsEvent.addBankAccount,
                                      message: {
                                        'accountHoldersName':
                                            _accountHoldersName.text,
                                        'ifscCode': _ifscCode.text,
                                        'accountNumber': _bankAccountNumber.text
                                      },
                                      onHandled: (e, m) {
                                        Navigator.pop(context);
                                        _accountHoldersName.clear();
                                        _ifscCode.clear();
                                        _bankAccountNumber.clear();
                                        if (m.updated) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                    "Account added successfully!",
                                                    style: TextStyle(
                                                        color: PrimaryColors
                                                            .backgroundColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                    "Invalid Account!",
                                                    style: TextStyle(
                                                        color: PrimaryColors
                                                            .backgroundColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              });
                                        }
                                      },
                                    );
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: OutlineButton(
                                borderSide: BorderSide(width: 2),
                                highlightedBorderColor:
                                    PrimaryColors.backgroundColor,
                                textColor: PrimaryColors.backgroundColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Decline',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _newVpaAddressForm(context) {
    showModalBottomSheet(
        backgroundColor: PrimaryColors.backgroundcolorlight,
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                (_bloc.latestViewModel.addingVpaAccount)
                    ? LinearProgressIndicator()
                    : SizedBox(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 8),
                          child: Text(
                            "Add VPA/UPI",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Form(
                        key: _vpaKey,
                        autovalidate: _vpaValidate,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: _vpaController,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please Enter Your VPA/UPI';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  labelText: 'xyz@upi',
                                  labelStyle: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                textColor: Colors.yellow,
                                color: PrimaryColors.backgroundColor,
                                onPressed: () {
                                  if (_vpaKey.currentState.validate()) {
                                    _bloc.fire(BankDetailsEvent.addVpaAddress,
                                        message: {
                                          'vpa': _vpaController.text
                                              .toString()
                                              .trim()
                                        }, onHandled: (e, m) {
                                      Navigator.pop(context);
                                      if (m.vpaAdded) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                  "VPA added successfully!",
                                                  style: TextStyle(
                                                      color: PrimaryColors
                                                          .backgroundColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              );
                                            });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                  "Invalid Vpa!",
                                                  style: TextStyle(
                                                      color: PrimaryColors
                                                          .backgroundColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              );
                                            });
                                      }
                                    }, onFired: (e, m) {
                                      _vpaController.clear();
                                    });
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: OutlineButton(
                                borderSide: BorderSide(width: 2),
                                highlightedBorderColor:
                                    PrimaryColors.backgroundColor,
                                textColor: PrimaryColors.backgroundColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Decline',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
