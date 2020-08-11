import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  bool visible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          getDetails();

        },
        child: Text("TAP"),
      ),
    );
  }

  void getDetails(){
    _showDialogBox();
  }
  _showDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 10), ()async{
            Navigator.pop(context);
          });
          return Wrap(
            children: <Widget>[
              Stack(
                children: [

                  Column(
                    children: <Widget>[
                      SizedBox(height: 35,),
                      Dialog(
                        insetPadding: EdgeInsets.all(10),
                        child: Container(
                          height: 200,
                          child: Row(
                            children: <Widget>[
                              RaisedButton(
                                child: Text("YES"),
                                onPressed: () {},
                              ),
                              RaisedButton(
                                child: Text("NO"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(child: Image(image: AssetImage("assets/images/full.png"),height: 70, width: 70,)),
                  ),],

              )
            ],
          );
        });
  }
}
