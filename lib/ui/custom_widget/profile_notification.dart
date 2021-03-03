import 'package:fixbee_partner/ui/custom_widget/profile_notification_widget.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';
class ProfileNotification extends StatefulWidget {
  @override
  _ProfileNotificationState createState() => _ProfileNotificationState();
}

class _ProfileNotificationState extends State<ProfileNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "UPDATES",
                style: TextStyle(
                    color: PrimaryColors.yellowColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            ProfileNotificationWidget(title: 'FIXBEE',
              description: 'Add documents to get verified',
              excerpt: 'Last date 25th-March 20221',
            ),

          ],
        ),
      ),
    );
  }
}
