import 'package:flutter/material.dart';

class CustomButtonType2 extends StatefulWidget {
  final String text;
  final Icon icon;
  final Function onTap;

  const CustomButtonType2(
      {Key key, @required this.text, @required this.onTap, this.icon})
      : super(key: key);

  @override
  _CustomButtonType2State createState() => _CustomButtonType2State();
}

class _CustomButtonType2State extends State<CustomButtonType2> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Theme.of(context).primaryColor,
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon,
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).canvasColor, fontSize: 12),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
