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
  bool selectedAll;
    void checkAll() {
    int i = 0;
    for (int x = 0; x < widget.subServices.length; x++) {
      if (widget.subServices[i].selected == true) i++;
    }
    if (i == widget.subServices.length)
     setState(() {
       selectedAll=true;
     });
    else{
      setState(() {
        selectedAll=false;
      });
    }
  }
  @override
  void initState() {
      checkAll();
    // TODO: implement initState
    super.initState();
  }


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
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Container(
                      child: Text("Select All"),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Switch(
                      value: selectedAll,
                      inactiveThumbColor: Colors.black12,
                      inactiveTrackColor: Colors.white70,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        for (int i = 0; i < widget.subServices.length; i++) {
                          widget.subServices[i].selected = value;
                          widget.onServiceChecked(widget.subServices[i],
                              widget.subServices[i].selected);
                        }
                        setState(() {
                          selectedAll = value;
                        });
                      },
                    )
                  ],
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
                      value: (selectedAll) ? true : subService.selected,
                      onChanged: (bool value) {
                        setState(() {
                          if (!value) selectedAll = false;
                          subService.selected = value;
                          widget.onServiceChecked(subService, value);
                          checkAll();
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
