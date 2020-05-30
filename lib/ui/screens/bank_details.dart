import 'package:fixbee_partner/blocs/bank_update_bloc.dart';
import 'package:fixbee_partner/events/bank_update_event.dart';
import 'package:fixbee_partner/models/bank_update_model.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class BankDetails extends StatefulWidget {
  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  TextEditingController _bankAccountNumber = TextEditingController();
  TextEditingController _ifscCode = TextEditingController();
  TextEditingController _accountHoldersName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  BankUpdateBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = BankUpdateBloc(BankUpdateModel());
    _bloc.fire(BankUpdateEvent.fetchBankDetails, onHandled: (e, m) {
      _bankAccountNumber = TextEditingController(text: m.bankAccountNumber);
      _accountHoldersName = TextEditingController(text: m.accountHoldersName);
      _ifscCode = TextEditingController(text: m.ifscCode);
    });
  }

  @override
  void dispose() {
    _bankAccountNumber.dispose();
    _ifscCode.dispose();
    _accountHoldersName.dispose();
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
            return ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  height: 60,
                  color: Colors.yellow[600],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_left,
                            color: Colors.black,
                            size: 25,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Registration()));
                          },
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 20),
                        Center(
                            child: Text(
                          "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _bloc.fire(BankUpdateEvent.updateBakDetails,
                                message: {
                                  'accountHoldersName': _accountHoldersName.text,
                                  'ifscCode': _ifscCode.text,
                                  'accountNumber': _bankAccountNumber.text
                                });
                            Navigator.pop(context);
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
                )
              ],
            );
          }),
        ));
  }
}
