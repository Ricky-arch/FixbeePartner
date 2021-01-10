import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:flutter/material.dart';

class ParentServiceWidget extends StatefulWidget {
  final List<ServiceOptionModel> parentService;
  const ParentServiceWidget({Key key, this.parentService}) : super(key: key);
  @override
  _ParentServiceWidgetState createState() => _ParentServiceWidgetState();
}

class _ParentServiceWidgetState extends State<ParentServiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Divider(thickness: 2,color: Colors.white,),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.parentService.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal:12.0, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.white)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 75,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: (widget
                                            .parentService[index].imageLink !=
                                        null)
                                    ? widget.parentService[index].imageLink
                                    : 'https://images.pexels.com/photos/162553/keys-workshop-mechanic-tools-162553.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            widget.parentService[index].serviceName,
                            style: TextStyle(
                                color: PrimaryColors.backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
