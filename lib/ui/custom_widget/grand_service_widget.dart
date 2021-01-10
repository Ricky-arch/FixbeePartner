import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';

class GrandService extends StatefulWidget {
  final String imageUrl;
  final String id;
  final String grandServiceName;
  final Function(String) onClick;
  final Widget children;
  const GrandService(
      {Key key,
      this.imageUrl,
      this.grandServiceName,
      this.onClick,
      this.children,
      this.id})
      : super(key: key);
  @override
  _GrandServiceState createState() => _GrandServiceState();
}

class _GrandServiceState extends State<GrandService> {
  String id = "";

  @override
  Widget build(BuildContext context) {
    return
      Container(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return Text(widget.grandServiceName);
                //   Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                //   child: Row(
                //     children: [
                //       Container(
                //         height: 60,
                //         width: 75,
                //         child: Padding(
                //           padding:
                //           const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                //           child: CachedNetworkImage(
                //               fit: BoxFit.cover,
                //               imageUrl: (widget.imageUrl != null)
                //                   ? widget.imageUrl
                //                   : 'https://images.pexels.com/photos/162553/keys-workshop-mechanic-tools-162553.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Container(
                //         width: MediaQuery.of(context).size.width / 2,
                //         child: Text(
                //           widget.grandServiceName.toUpperCase(),
                //           style: TextStyle(
                //               color:PrimaryColors.backgroundColor,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 14),
                //         ),
                //       ),
                //     ],
                //   ),
                // );
              },
            )
          ],
        ),
      );
  }
}
