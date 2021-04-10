import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:fixbee_partner/utils/excerpt.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';
import '../../data_store.dart';

class AddNewServiceBanner extends StatefulWidget {
  final String serviceName;
  final Excerpt excerpt;
  final Function(ServiceOptionModel subservice, bool value) onServiceChecked;
  final Function onNext;
  final List<ServiceOptionModel> subServices;
  final ServiceOptionModel subService;

  const AddNewServiceBanner(
      {Key key,
      this.serviceName,
      this.onServiceChecked,
      this.onNext,
      this.subServices,
      this.subService,
      this.excerpt})
      : super(key: key);

  @override
  _AddNewServiceBannerState createState() => _AddNewServiceBannerState();
}

class _AddNewServiceBannerState extends State<AddNewServiceBanner> {
  bool value = false;
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
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 75,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: (widget.subService.imageLink == null)
                        ? Image.asset("assets/logo/new_launcher_icon.png")
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.subService.imageLink,
                            httpHeaders: {'authorization': DataStore.token},
                          ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                          child: Text(
                            widget.serviceName,
                            style: TextStyle(
                                color: (value)
                                    ? Colors.red
                                    : PrimaryColors.backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                          child: _footer(widget.excerpt),
                        )
                      ],
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.black,
                    activeColor: Colors.red,
                    value: value,
                    onChanged: (bool v) {
                      setState(() {
                        value = v;
                        widget.subService.selected = v;
                        widget.onServiceChecked(widget.subService, value);
                      });
                      print(widget.subService.id.toString());
                    },
                  ),
                ],
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
          color: PrimaryColors.backgroundColor.withOpacity(.5),
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
                  color: PrimaryColors.backgroundColor.withOpacity(0.5),
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
