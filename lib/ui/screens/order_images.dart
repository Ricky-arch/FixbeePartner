import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/blocs/order_image_bloc.dart';
import 'package:fixbee_partner/events/order_image_event.dart';
import 'package:fixbee_partner/models/order_images_model.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

import '../../Constants.dart';
import '../../data_store.dart';

class OrderImages extends StatefulWidget {
  @override
  _OrderImagesState createState() => _OrderImagesState();
}

class _OrderImagesState extends State<OrderImages> {
  OrderImageBloc _bloc;

  String urlConstructor(id) {
    return EndPoints.DOCUMENT + id;
  }

  @override
  void initState() {
    _bloc = OrderImageBloc(OrderImagesModel());

    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12,20,12,0),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Order  ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: "Gallery",
                      style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: _bloc.getImageIds(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: PrimaryColors.backgroundColor,
                  );
                else {
                  if (snapshot.data.length == 0)
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'NO IMAGE HAS BEEN UPLOADED IMAGE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    );
                }
                return SingleChildScrollView(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: PinchZoomImage(
                            image: CachedNetworkImage(
                              imageUrl: urlConstructor(snapshot.data[index]),
                              placeholder: (context, url) {
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    height: 65,
                                    width: 50,
                                    child: CustomCircularProgressIndicator(),
                                  ),
                                );
                              },
                              httpHeaders: {
                                'authorization': '${DataStore.token}'
                              },
                            ),
                            zoomedBackgroundColor:
                                Color.fromRGBO(240, 240, 240, 1.0),
                            hideStatusBarWhileZooming: false,
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}
