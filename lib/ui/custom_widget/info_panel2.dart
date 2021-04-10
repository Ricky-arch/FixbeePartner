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

      children: <Widget>[
        Expanded(
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).canvasColor, borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        ),
      ],
    );
  }
}
