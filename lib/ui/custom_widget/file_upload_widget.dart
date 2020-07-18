import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants.dart';

class FileUploadWidget extends StatelessWidget {
  final Function(String path) onImagePicked;
  final String imageURl;
  final bool loading;
  final ImagePicker _imagePicker = ImagePicker();
  final Widget text;

  FileUploadWidget(
      {Key key, this.onImagePicked, this.imageURl, this.loading = true, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: PrimaryColors.backgroundColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            (imageURl == null || imageURl.isEmpty)
                ? Text('Upload your aadhaar card')
                : text,
            Spacer(),
            InkWell(
              onTap: () async {
                PickedFile image =
                    await _imagePicker.getImage(source: ImageSource.gallery);
                if (image != null) onImagePicked(image.path);
              },
              child: Icon(
                LineAwesomeIcons.folder,
                color: PrimaryColors.backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
