import 'package:flutter/material.dart';
class InfoPanel extends StatelessWidget {
  final String title, answer;
  final int maxLines;

  const InfoPanel({Key key, this.title, this.answer, this.maxLines})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(

          children: <Widget>[
            Expanded(
              child: Container(

                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  answer,
                  textAlign: TextAlign.end,
                  maxLines: null,
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}