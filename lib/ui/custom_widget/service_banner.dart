import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/utils/excerpt.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';
import '../../data_store.dart';

class ServiceBanner extends StatefulWidget {
  final String serviceName;
  final bool showDeleteIcon;
  final Function deleteService;
  final String image;
  final Excerpt excerpt;

  const ServiceBanner(
      {Key key,
      this.serviceName,
      this.showDeleteIcon,
      this.deleteService,
      this.image,
      this.excerpt})
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
                color: Theme.of(context).cardColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 75,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: (widget.image == null)
                          ? Image.asset("assets/logo/new_launcher_icon.png")
                          : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget.image,
                              httpHeaders: {'authorization': DataStore.token},
                            ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.serviceName,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _footer(widget.excerpt)
                          ],
                        ),
                      ),
                    ),
                    (widget.showDeleteIcon)
                        ? Container(
                            child: GestureDetector(
                              onTap: widget.deleteService,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).hintColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _footer(Excerpt excerpt) {
    if (excerpt.bulletPoints != null && excerpt.bulletPoints.isNotEmpty)
      return Column(
        children: excerpt.bulletPoints.map((e) {
          return excerptField(e);
        }).toList(),
      );
    else if (excerpt.text != null && excerpt.text.isNotEmpty)
      return excerptField(excerpt.text);
    else if (excerpt.rawString != null && excerpt.rawString.isNotEmpty)
      return excerptField(excerpt.rawString);
    else
      return SizedBox();
  }

  Widget excerptField(String excerpt) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: Theme.of(context).hintColor,
          size: 5,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              excerpt ?? "",
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
