import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:flutter/material.dart';

class DocumentViewerPage extends StatefulWidget {
  final String documentName;
  final String documentKey;

  const DocumentViewerPage({Key key, this.documentName, this.documentKey})
      : super(key: key);
  @override
  _DocumentViewerPageState createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  String urlConstructor() {
    return EndPoints.DOCUMENT + widget.documentKey;
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
          title: Text(
            widget.documentName.toString().toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: PrimaryColors.whiteColor),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: CachedNetworkImage(
            placeholder: (context, url) {
              return CircularProgressIndicator();
            },
            imageUrl: urlConstructor(),
            httpHeaders: {'authorization': '${DataStore.token}'},
          )),
        ),
      ),
    );
  }
}
