import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_picker/image_picker.dart';

class DisplayPicture extends StatelessWidget {
  final Function(String path) onImagePicked;
  final String imageURl;
  final bool loading;
  final ImagePicker _imagePicker = ImagePicker();
  DisplayPicture({
    Key key,
    @required this.onImagePicked,
    @required this.imageURl,
    this.loading = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(0.010 * MediaQuery.of(context).size.width),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).canvasColor,
              ),
              child: Padding(
                padding:
                    EdgeInsets.all(0.010 * MediaQuery.of(context).size.width),
                child: CircleAvatar(
                  radius: 0.13 * MediaQuery.of(context).size.width,
                  backgroundImage: (imageURl == null || imageURl.isEmpty)
                      ? null
                      : CachedNetworkImageProvider(imageURl),
                  child: (imageURl == null || imageURl.isEmpty)
                      ? SvgPicture.asset(
                          "assets/logo/bee_outline.svg",
                          width: 0.4 * MediaQuery.of(context).size.width,
                          height: 0.4 * MediaQuery.of(context).size.width,
                        )
                      : SizedBox(),
                ),
              ),
            ),
          ),
        ),
        loading
            ? Positioned(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    backgroundColor: Colors.white,
                  ),
                  height: 0.3 * MediaQuery.of(context).size.width,
                  width: 0.3 * MediaQuery.of(context).size.width,
                ),
              )
            : SizedBox(),
        Positioned(
          bottom: 0.004 * MediaQuery.of(context).size.height,
          right: 0.004 * MediaQuery.of(context).size.height,
          child: InkWell(
            onTap: () async {
              PickedFile image =
                  await _imagePicker.getImage(source: ImageSource.gallery);
              if (image != null) onImagePicked(image.path);
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

