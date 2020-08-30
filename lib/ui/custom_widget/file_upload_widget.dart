import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(String path) onImagePicked;
  final String inputString;
  final String imageURl;
  final bool loading;
  final Widget text;
  final bool uploading;

  FileUploadWidget(
      {Key key, this.onImagePicked, this.imageURl, this.loading = true, this.text, this.inputString, this.uploading})
      : super(key: key);

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();

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
            (widget.imageURl == null || widget.imageURl.isEmpty)
                ? Text(widget.inputString)
                : widget.text,
            Spacer(),
            InkWell(
              onTap: () async {
                PickedFile image =
                    await _imagePicker.getImage(source: ImageSource.gallery);
                if (image != null) widget.onImagePicked(image.path);
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
