import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants.dart';

class NoInternetWidget extends StatefulWidget {
  final Function retryConnecting;
  final bool loading;

  const NoInternetWidget({Key key, this.retryConnecting, this.loading})
      : super(key: key);
  @override
  _NoInternetWidgetState createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Image.asset(
          "assets/logo/dead_bee.png",
          height: 100,
          width: 100,
        )),
        SizedBox(
          height: 20,
        ),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "OOPS!",
                style: TextStyle(
                    color: PrimaryColors.backgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "\nUnable to connect to server!",
                style: TextStyle(
                    color: PrimaryColors.backgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        (!widget.loading)
            ? InkWell(
                child: GestureDetector(
                  onTap: widget.retryConnecting,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.orangeAccent.withOpacity(.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "RETRY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: PrimaryColors.backgroundColor,
              ),
      ],
    );
  }
}
