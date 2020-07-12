import 'package:fixbee_partner/blocs/bank_details_bloc.dart';
import 'package:fixbee_partner/events/bank_details_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
import 'package:fixbee_partner/ui/custom_widget/available_accounts.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColors.backgroundColor,
        automaticallyImplyLeading: false,
        //backgroundColor: Data.backgroundColor,
        title: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: PrimaryColors.backgroundColor),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Bank Accounts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                  fontSize: 22)),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.yellow,
                      ),
                      onPressed: () {},
                    )
                  ],
                ))
          ],
        ),
      ),
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return Column(
          children: [
            (viewModel.bankAccountList.length == 0)
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "No Accounts Linked",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _newAccountForm(context);
                    },
                    child: Container(
                        decoration:
                            BoxDecoration(color: PrimaryColors.backgroundColor),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Add an account?",
                            style:
                                TextStyle(fontSize: 16, color: Colors.yellow),
                          ),
                        )),
                  ),
                )
              ],
            )
          ],
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (ctx) {
                      return BankDetails();
                    }));
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
        context: context,
        builder: (context) {
          return Wrap(children: [
            Container(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add your bank details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.black),
                                labelText: "Bank Account Number",
                                labelStyle: TextStyle(color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepOrange, width: 2.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
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
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.black),
                                labelText: "IFSC Code",
                                labelStyle: TextStyle(color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepOrange, width: 2.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
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
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.black),
                                labelText: "Bank Account Holders Name",
                                labelStyle: TextStyle(color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepOrange, width: 2.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _bloc.fire(BankDetailsEvent.updateBankAccount,
                                    message: {
                                      'accountHoldersName':
                                          _accountHoldersName.text,
                                      'ifscCode': _ifscCode.text,
                                      'accountNumber': _bankAccountNumber.text
                                    }, onHandled: (e, m) {
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "CONFIRM",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: OutlineButton(
                            highlightedBorderColor: Colors.red,
                            textColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'DECLINE',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]);
        });
  }
}
