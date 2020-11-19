import 'package:flutter/material.dart';

class CustomButtonType1 extends StatefulWidget {
  final Function onTap;

  final String text;
  final flexibleSize;

  const CustomButtonType1(
      {Key key,
      @required this.onTap,
      @required this.text,
      @required this.flexibleSize})
      : super(key: key);

  @override
  _CustomButtonType1State createState() => _CustomButtonType1State();
}

class _CustomButtonType1State extends State<CustomButtonType1> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 12, 12),
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - widget.flexibleSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.orangeAccent.withOpacity(.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
