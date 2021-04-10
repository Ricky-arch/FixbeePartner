import 'package:fixbee_partner/blocs/add_vpa_bloc.dart';
import 'package:fixbee_partner/models/add_vpa_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

import '../../Constants.dart';

class VpaWithdrawal extends StatefulWidget {
  final Function(String) addVpa;

  const VpaWithdrawal({Key key, this.addVpa}) : super(key: key);
  @override
  _VpaWithdrawalState createState() => _VpaWithdrawalState();
}

class _VpaWithdrawalState extends State<VpaWithdrawal> {
  bool _obscureText = true;
  TextEditingController controllerInitial;
  TextEditingController controllerFinal;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  AddVpaBloc _bloc;

  bool enabled = false;
  @override
  void initState() {
    controllerInitial = TextEditingController();
    controllerFinal = TextEditingController();
    _bloc = AddVpaBloc(AddVpaModel());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    controllerInitial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(


        body: Column(
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
                      "VPA/UPI",
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
                    accountTextField(controllerInitial, 'Add VPA', true, (val) {
                      if (val.trim().isEmpty)
                        return 'Empty';
                      else if (!val.trim().toString().contains('@'))
                        return 'Invalid UPI format';
                      return null;
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    accountTextField(controllerFinal, 'Retype VPA', false,
                        (val) {
                      if (val.isEmpty) return 'Empty';
                      if (val != controllerInitial.text) return 'Not Match';
                      return null;
                    }),
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
                  padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 12),
                  child: FlatButton(
                    disabledColor: Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_form.currentState.validate()) {
                        widget.addVpa(controllerInitial.text);
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
    );
  }

  _showMessageDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: PrimaryColors.backgroundColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          );
        });
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
              obscureText: (obscure) ? _obscureText : false,
              obscuringCharacter: "●",
              validator: validator,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              enableInteractiveSelection: false,
              controller: controller,
              enabled: true,
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(

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
                  borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                ),
                errorStyle:
                    TextStyle(fontWeight: FontWeight.bold),


                suffixIcon: (obscure)
                    ? IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        color: _obscureText ? Colors.grey : Colors.red,
                        onPressed: () {
                          _toggle();
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

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
