import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants.dart';

class ProfileNotificationWidget extends StatefulWidget {
  final String title, description, excerpt, picture;

  const ProfileNotificationWidget(
      {Key key, this.title, this.description, this.excerpt, this.picture})
      : super(key: key);
  @override
  _ProfileNotificationWidgetState createState() =>
      _ProfileNotificationWidgetState();
}

class _ProfileNotificationWidgetState extends State<ProfileNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: PrimaryColors.backgroundColor,
            border: Border.all(color: PrimaryColors.whiteColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      backgroundColor: PrimaryColors.yellowColor,
                      radius: 10,
                      // backgroundImage:
                      //     (widget.picture == null)
                      //         ? DataStore?.me?.dpUrl == null
                      //             ? null
                      //             : CachedNetworkImageProvider(
                      //                 widget.picture)
                      //         : CachedNetworkImageProvider(imageURl),
                      child: (widget.picture == null)
                          ? SvgPicture.asset(
                              "assets/logo/bee_outline.svg",
                              width: 15,
                              height: 15,
                            )
                          : SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.title.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.orange),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.description,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: PrimaryColors.whiteColor),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.excerpt,
                style: TextStyle(fontSize: 15, color: PrimaryColors.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
