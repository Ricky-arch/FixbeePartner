import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final bool slotted;
  final DateTime slot;

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
      this.slotted = false})
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Text(
                  'Got a job for you',
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
                        backgroundImage: NetworkImage(
                            'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
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
                                  Row(
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.phone,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          _callPhone(widget.userNumber == null
                                              ? "tel:+918132802897"
                                              : widget.userNumber);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(widget.addressLine == null
                                      ? 'AddressLine'
                                      : widget.addressLine),
                                  Text(
                                    widget.serviceName == null
                                        ? "Plumbing"
                                        : widget.serviceName +
                                            " - " +
                                            widget.paymentMode,
                                    textAlign: TextAlign.left,
                                    maxLines: null,
                                  ),
                                  widget.slotted
                                      ? Text(
                                          'Scheduled at:\n' +
                                              widget.slot.toIso8601String(),
                                          textAlign: TextAlign.left,
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
                            color: Colors.green,
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
                            highlightedBorderColor: Colors.red,
                            textColor: Colors.red,
                            onPressed: widget.onDecline,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'DECLINE',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
