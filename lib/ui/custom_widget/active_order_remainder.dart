
import 'package:fixbee_partner/animations/clip_design/message.dart';
import 'package:flutter/material.dart';


class ActiveOrderRemainder extends StatefulWidget {
  final Function workScreen;

  const ActiveOrderRemainder({Key key, this.workScreen}) : super(key: key);
  @override
  _ActiveOrderRemainderState createState() => _ActiveOrderRemainderState();
}

class _ActiveOrderRemainderState extends State<ActiveOrderRemainder> {

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Message(
                triangleX1: 50.0,
                triangleX2: 80.0,
                triangleX3: 80.0,
                triangleY1: 20.0,
                child: GestureDetector(
                  onTap: widget.workScreen,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,8,8,30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: Colors.orangeAccent,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "ORDER PENDING!",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
