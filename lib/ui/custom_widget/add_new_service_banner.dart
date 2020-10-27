import 'package:fixbee_partner/models/service_options.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class AddNewServiceBanner extends StatefulWidget {
  final String serviceName;
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
      this.subService})
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        widget.serviceName,
                        style: TextStyle(
                            color: (value)
                                ? Colors.red
                                : PrimaryColors.backgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


}
