import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class OtpDigitWidget extends StatefulWidget {
  final String digit;
  final bool onFocus;
  final TextEditingController digitController;
  final Function(String) onChanged;

  const OtpDigitWidget({Key key, this.digitController, this.onChanged, this.digit, this.onFocus}) : super(key: key);
  @override
  _OtpDigitWidgetState createState() => _OtpDigitWidgetState();
}

class _OtpDigitWidgetState extends State<OtpDigitWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: PrimaryColors.backgroundColor)
        ),
        width: MediaQuery.of(context).size.width/8,
        height: MediaQuery.of(context).size.width/8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(

            ),
            textAlign: TextAlign.center,
            controller: widget.digitController,
            autofocus: true,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            showCursor: false,
            enableInteractiveSelection: false,
            onChanged: widget.onChanged,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            inputFormatters: [LengthLimitingTextInputFormatter(1)],

          ),
        ),
      ),
    );
  }
}
