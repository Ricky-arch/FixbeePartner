import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/models/service_options.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  final List<ServiceOptionModel> serviceModels;
  final Function(List<ServiceOptionModel>) onServiceSelected;

  const Services(this.serviceModels, {this.onServiceSelected});

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.yellow),
          height: 55,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 8),
            child: Text(
              "Services",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: widget.serviceModels.map((model) {
              return GestureDetector(
                onTap: () {
                  widget.onServiceSelected(model.subServices);
                },
                child: ServiceItem(model),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ServiceItem extends StatefulWidget {
  final ServiceOptionModel serviceModel;

  const ServiceItem(this.serviceModel);
  @override
  _ServiceItemState createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: AspectRatio(
                aspectRatio: 84 / 69,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.serviceModel.imageLink),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.serviceModel.serviceName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                            height: 8,
                            width: 8,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Available",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.more_vert),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
