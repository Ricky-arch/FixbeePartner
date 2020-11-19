import 'package:flutter/material.dart';

class InfoPanel2 extends StatefulWidget {
  final String title, value;

  const InfoPanel2({Key key, this.title, this.value}) : super(key: key);
  @override
  _InfoPanel2State createState() => _InfoPanel2State();
}

class _InfoPanel2State extends State<InfoPanel2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
          child: Text(
            widget.title,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: 250,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              (widget.value != null) ? widget.value : "Ram Mandir",
              overflow: TextOverflow.clip,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }
}
