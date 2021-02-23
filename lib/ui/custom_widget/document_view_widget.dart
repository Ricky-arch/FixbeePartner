import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';



class DocumentViewerPage extends StatefulWidget {
  final String documentName;
  final String documentID;

  const DocumentViewerPage({Key key, this.documentName, this.documentID}) : super(key: key);
  @override
  _DocumentViewerPageState createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {

  String urlConstructor(){
    return EndPoints.DOCUMENT+"/?id=3oi8g2qmkjyn5bo7";
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColors.backgroundColor,
          title: Text("Document",style: TextStyle(fontWeight: FontWeight.bold, color: PrimaryColors.whiteColor),),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Image.network(urlConstructor())),
        ),

      ),
    );
  }
}
