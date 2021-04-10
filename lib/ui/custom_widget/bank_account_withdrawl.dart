import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../../Constants.dart';

class BankAccountWithdrawal extends StatefulWidget {
  final Function(Map<String, String>) bankDetails;

  const BankAccountWithdrawal({Key key, this.bankDetails}) : super(key: key);
  @override
  _BankAccountWithdrawalState createState() => _BankAccountWithdrawalState();
}

class _BankAccountWithdrawalState extends State<BankAccountWithdrawal> {
  TextEditingController accountNumberControllerInitial;
  bool _obscureAccountNumber = true, _obscureIfsc = true;
  TextEditingController accountNumberControllerFinal;
  TextEditingController ifscControllerInitial;
  TextEditingController ifscControllerFinal;
  TextEditingController accountHolderName;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  @override
  void initState() {
    accountNumberControllerInitial = TextEditingController();
    accountNumberControllerFinal = TextEditingController();
    ifscControllerInitial = TextEditingController();
    ifscControllerFinal = TextEditingController();
    accountHolderName = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Add valid  ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(
                        text:
                        "Bank Account Details",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      accountTextField(accountNumberControllerInitial,
                          'Add Bank Account Number', true, (val) {
                        if (val.trim().isEmpty)
                          return 'Empty';
                        else if (!(isNumeric(val.trim())))
                          return 'Invalid Account Number Format';
                        return null;
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      accountTextField(accountNumberControllerFinal,
                          'Retype Bank Account Number', false, (val) {
                        if (val.trim().isEmpty) return 'Empty';
                        if (val != accountNumberControllerInitial.text)
                          return 'Not Match';
                        return null;
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      ifscTextField(ifscControllerInitial, 'Add IFSC', true,
                          (val) {
                        if (val.trim().isEmpty)
                          return 'Empty';
                        else if (!(isAlphanumeric(val.trim())))
                          return 'Invalid IFSC Format';
                        return null;
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      ifscTextField(ifscControllerFinal, 'Retype IFSC', false,
                          (val) {
                        if (val.trim().isEmpty)
                          return 'Empty';
                        else if (val != ifscControllerInitial.text)
                          return 'Not Match';
                        return null;
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      accountTextField(accountHolderName,
                          'Add Account Holder\'s Name', false, (val) {
                        if (val.trim().isEmpty) return 'Empty';
                      })
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_form.currentState.validate()) {
                          Map<String, String> bankAccountDetails={};
                          bankAccountDetails['accountNumber']=accountNumberControllerFinal.text;
                          bankAccountDetails['ifsc']=ifscControllerFinal.text;
                          bankAccountDetails['accountHolderName']=accountHolderName.text;
                          widget.bankDetails(bankAccountDetails);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                color: Theme.of(context).canvasColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountTextField(controller, titleText, obscure, Function validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: TextStyle(
              color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: TextFormField(
              obscureText: (obscure) ? _obscureAccountNumber : false,
              obscuringCharacter: "●",
              validator: validator,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              enableInteractiveSelection: false,
              controller: controller,
              enabled: true,
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                // fillColor: Colors.white,
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
                ),
                errorStyle:
                    TextStyle(fontWeight: FontWeight.bold),


                suffixIcon: (obscure)
                    ? IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        color: _obscureAccountNumber ? Colors.grey : Colors.red,
                        onPressed: () {
                          _toggleAccountNumber();
                        },
                      )
                    : SizedBox(),
              ),
              // controller: widget.controller,
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget ifscTextField(controller, titleText, obscure, Function validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: TextStyle(
              color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: TextFormField(
              obscureText: (obscure) ? _obscureIfsc : false,
              obscuringCharacter: "●",
              validator: validator,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              enableInteractiveSelection: false,
              controller: controller,
              enabled: true,
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                // fillColor: Colors.white,
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
                ),
                errorStyle:
                    TextStyle(fontWeight: FontWeight.bold),
                // labelText: 'xyz@upi',
                labelStyle: TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                ),

                suffixIcon: (obscure)
                    ? IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        color: _obscureIfsc ? Colors.grey : Colors.red,
                        onPressed: () {
                          _toggleIfsc();
                        },
                      )
                    : SizedBox(),
              ),
              // controller: widget.controller,
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleAccountNumber() {
    setState(() {
      _obscureAccountNumber = !_obscureAccountNumber;
    });
  }

  void _toggleIfsc() {
    setState(() {
      _obscureIfsc = !_obscureIfsc;
    });
  }
}
