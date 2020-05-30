import 'package:fixbee_partner/models/service_options.dart';
import 'package:flutter/material.dart';

class SkillSetBottomSheet extends StatefulWidget {
  final List<ServiceOptionModel> subServices;
  final Function(ServiceOptionModel subservice, bool value) onServiceChecked;
  final Function onNext;

  const SkillSetBottomSheet(
      {@required this.subServices, this.onServiceChecked, this.onNext});

  @override
  _SkillSetBottomSheetState createState() => _SkillSetBottomSheetState();
}

class _SkillSetBottomSheetState extends State<SkillSetBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff6f6fb),
      child: Wrap(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "What are you skilled at?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                height: 0.7,
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
          ListView(
              shrinkWrap: true,
              children: widget.subServices.map((subService) {
                return Row(
                  children: <Widget>[
                    Checkbox(
                      value: subService.selected,
                      onChanged: (bool value) {
                        setState(() {
                          subService.selected = value;
                          widget.onServiceChecked(subService, value);
                        });
                      },
                    ),
                    Text(subService.serviceName)
                  ],
                );
              }).toList()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () {
                  widget.onNext();
                },
                child: Text("Next"),
                textColor: Colors.white,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
