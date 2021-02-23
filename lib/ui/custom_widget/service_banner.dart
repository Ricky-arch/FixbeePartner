import 'package:flutter/material.dart';

import '../../Constants.dart';

class ServiceBanner extends StatefulWidget {
  final String serviceName;
  final bool showDeleteIcon;
  final Function deleteService;

  const ServiceBanner({Key key, this.serviceName, this.showDeleteIcon, this.deleteService})
      : super(key: key);
  @override
  _ServiceBannerState createState() => _ServiceBannerState();
}

class _ServiceBannerState extends State<ServiceBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.tealAccent)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width/2,
                            child: Text(
                              widget.serviceName,
                              maxLines: null,
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(

                                  color: PrimaryColors.backgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Spacer(),
                        (widget.showDeleteIcon)
                            ? Container(
                              child: GestureDetector(
                                  onTap: widget.deleteService,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
