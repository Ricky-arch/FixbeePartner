import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

import 'package:image_picker/image_picker.dart';

class DisplayPicture extends StatefulWidget {
  final Function(String path) onImagePicked;
  final String imageURl;
  final bool loading;
  final bool verified;
  final Function(bool) onVerifiedBee;
  final Function showRuleSheet;

  DisplayPicture({
    Key key,
    @required this.onImagePicked,
    @required this.imageURl,
    this.loading = true,
    this.verified,
    this.onVerifiedBee,
    this.showRuleSheet,
  }) : super(key: key);

  @override
  _DisplayPictureState createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(0.010 * MediaQuery.of(context).size.width),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    EdgeInsets.all(0.010 * MediaQuery.of(context).size.width),
                child: widget.loading
                    ? Center(
                        child: SizedBox(
                          height: 0.2 * MediaQuery.of(context).size.width,
                          width: 0.2 * MediaQuery.of(context).size.width,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).accentColor),
                            backgroundColor: Theme.of(context).canvasColor,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: PrimaryColors.backgroundcolorlight,
                        radius: 0.13 * MediaQuery.of(context).size.width,
                        backgroundImage: (widget.imageURl == null ||
                                widget.imageURl.isEmpty)
                            ? DataStore?.me?.dpUrl == null
                                ? null
                                : CachedNetworkImageProvider(DataStore.me.dpUrl,
                                    headers: {
                                        'authorization': '${DataStore.token}'
                                      })
                            : CachedNetworkImageProvider(widget.imageURl,
                                headers: {
                                    'authorization': '${DataStore.token}'
                                  }),
                        child: (DataStore?.me?.dpUrl == null &&
                                widget.imageURl == null)
                            ? SvgPicture.asset(
                                "assets/logo/bee.svg",
                                width: 0.4 * MediaQuery.of(context).size.width,
                                height: 0.4 * MediaQuery.of(context).size.width,
                              )
                            : SizedBox(),
                      ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.004 * MediaQuery.of(context).size.height,
          right: 0.004 * MediaQuery.of(context).size.height,
          child: InkWell(
            onTap: () async {
              if (!widget.verified) {
                PickedFile image =
                    await _imagePicker.getImage(source: ImageSource.gallery);
                if (image != null) widget.onImagePicked(image.path);
              } else
                widget.onVerifiedBee(widget.verified);
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PrimaryColors.backgroundColor,
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  )),
              child: Padding(
                padding:
                    EdgeInsets.all(0.014 * MediaQuery.of(context).size.width),
                child: Icon(
                  Icons.edit,
                  size: 0.032 * MediaQuery.of(context).size.width,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
