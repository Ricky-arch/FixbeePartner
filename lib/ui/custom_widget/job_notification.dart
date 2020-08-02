import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants.dart';

class JobNotification extends StatefulWidget {
  final bool loading;
  final Function onDecline;
  final Function onConfirm;
  final String userName;
  final String addressLine;
  final String paymentMode;
  final String profilePicUrl;
  final String serviceName;
  final String quantity;
  final String userNumber;
  final String slotted;
  final String slot;
  final String orderId;

  const JobNotification(
      {Key key,
      this.loading = false,
      this.onDecline,
      this.onConfirm,
      this.userName,
      this.addressLine,
      this.paymentMode,
      this.serviceName,
      this.quantity,
      this.userNumber,
      this.slot,
      this.profilePicUrl,
      this.slotted,
      this.orderId})
      : super(key: key);

  @override
  _JobNotificationState createState() => _JobNotificationState();
}

class _JobNotificationState extends State<JobNotification> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _showDetailsModalSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Additional Job Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("The job is very very very very easy"),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Text(
                  "#Order: " + widget.orderId,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: 32,
                        child: widget.loading
                            ? CircularProgressIndicator()
                            : SizedBox(),
                        backgroundImage: widget.profilePicUrl != null
                            ? NetworkImage('http://' +
                                Constants.HOST_IP +
                                '//document?id=' +
                                (widget.profilePicUrl))
                            : AssetImage(
                                "assets/custom_icons/user.png",
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  widget.loading
                      ? SizedBox()
                      : Container(

                          //width: MediaQuery.of(context).size.width - 112,
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width-110,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                widget.userName == null
                                                    ? 'Holy Jesus'
                                                    : widget.userName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 200,
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.deepPurple),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.phone,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            onTap: () => launch(
                                                "tel://${widget.userNumber}"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.serviceName == null
                                            ? "Ghor Porishkar"
                                            : widget.serviceName +
                                            " - " +
                                            widget.paymentMode,
                                        textAlign: TextAlign.left,
                                        maxLines: null,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_drop_up),
                                        onPressed: () {
                                          _showDetailsModalSheet(context);
                                        },
                                      )
                                    ],
                                  ),
                                  Text(widget.addressLine == null
                                      ? 'AddressLine'
                                      : widget.addressLine),

                                  (widget.slotted.toString() == 'true')
                                      ? Text(
                                          'Scheduled at: \n' +
//                                              widget.slot.toIso8601String(),
                                              widget.slot,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                          maxLines: null,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              widget.loading
                  ? SizedBox()
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.deepPurple,
                            onPressed: widget.onConfirm,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "CONFIRM",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: OutlineButton(
                            borderSide:
                                BorderSide(color: Colors.deepPurple, width: 2),
                            highlightedBorderColor: Colors.red,
                            textColor: Colors.red,
                            onPressed: widget.onDecline,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'DECLINE',
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  _callPhone(phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
}
