import 'package:fixbee_partner/blocs/bank_details_bloc.dart';
import 'package:fixbee_partner/events/bank_details_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
import 'package:fixbee_partner/ui/custom_widget/available_accounts.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'package:string_validator/string_validator.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';

class BankDetails extends StatefulWidget {
  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  BankDetailsBloc _bloc;
  TextEditingController _bankAccountNumber = TextEditingController();
  TextEditingController _ifscCode = TextEditingController();
  TextEditingController _accountHoldersName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BankDetailsBloc(BankDetailsModel());
    _bloc.fire(BankDetailsEvent.fetchAvailableAccounts);
  }

  @override
  void dispose() {
    _bankAccountNumber.dispose();
    _ifscCode.dispose();
    _accountHoldersName.dispose();
    _bloc.extinguish();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    return Scaffold(
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return SafeArea(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 11,
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration:
                            BoxDecoration(color: PrimaryColors.backgroundColor),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'BANK ACCOUNTS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16)),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                _bankAccountInfo(context);
                              },
                            )
                          ],
                        ))
                  ],
                ),
              ),
              (viewModel.bankAccountList.length == 0)
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Oops! No Accounts Linked",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: viewModel.bankAccountList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Account $index"),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteAccount(viewModel
                                        .bankAccountList[index].accountID);
                                  },
                                )
                              ],
                            ),
                            AvailableAccounts(
                              accountHoldersName: viewModel
                                  .bankAccountList[index].accountHoldersName,
                              accountNumber: viewModel
                                  .bankAccountList[index].bankAccountNumber,
                              verified: viewModel
                                  .bankAccountList[index].accountVerified,
                            ),
                          ],
                        );
                      }),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    child: GestureDetector(
                      onTap: () {
                        _newAccountForm(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Add Bank Account",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  _deleteAccount(String id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Are you sure you want to delete the Bank Account?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  _bloc.fire(BankDetailsEvent.deleteBankAccount,
                      message: {"accountID": "$id"}, onHandled: (e, m) {
                    Navigator.pop(context);
                  });
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }

  _newAccountForm(context) {
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
                            "ADD YOUR BANK ACCOUNT DETAILS",
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
                        key: _formKey,
                        autovalidate: _validate,
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
//                                    enabledBorder: OutlineInputBorder(
//                                      borderSide: const BorderSide(
//                                          color: Colors.black, width: 2.0),
//                                      borderRadius: BorderRadius.circular(15.0),
//                                    )
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
//                                    enabledBorder: OutlineInputBorder(
//                                      borderSide: const BorderSide(
//                                          color: Colors.black, width: 2.0),
//                                      borderRadius: BorderRadius.circular(15.0),
//                                    )
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
//                                    enabledBorder: OutlineInputBorder(
//                                      borderSide: const BorderSide(
//                                          color: Colors.black, width: 2.0),
//                                      borderRadius: BorderRadius.circular(15.0),
//                                    )
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
                                  if (_formKey.currentState.validate()) {
                                    _bloc.fire(
                                      BankDetailsEvent.updateBankAccount,
                                      message: {
                                        'accountHoldersName':
                                            _accountHoldersName.text,
                                        'ifscCode': _ifscCode.text,
                                        'accountNumber': _bankAccountNumber.text
                                      },
                                      onHandled: (e, m) {
                                        if (m.updated) {
                                          _accountHoldersName.clear();
                                          _ifscCode.clear();
                                          _bankAccountNumber.clear();
                                          Navigator.pop(context);
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
                                          _accountHoldersName.clear();
                                          _ifscCode.clear();
                                          _bankAccountNumber.clear();
                                        }
                                      },
                                    );
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    "CONFIRM",
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
                                    'DECLINE',
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

  _bankAccountInfo(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container();
        });
  }
}
