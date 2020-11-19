import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(String path) onImagePicked;
  final String inputString;
  final String imageURl;
  final bool loading;
  final String documentName;
  final Widget text;
  final bool uploading;
  final FileUploadController controller;
  final bool alreadyUploaded;

  FileUploadWidget({
    Key key,
    this.onImagePicked,
    this.imageURl,
    this.loading = true,
    this.text,
    this.inputString,
    this.uploading,
    this.documentName,
    this.controller,
    this.alreadyUploaded,
  }) : super(key: key);

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  // final ImagePicker _imagePicker = ImagePicker();
  String fileName;
  bool _uploaded = false;

  @override
  void initState() {
    fileName = widget.inputString;
    widget?.controller?.onUpload = () {
      log('OnUPLOAD', name: 'onUp1');
      setState(() {
        _uploaded = true;
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.tealAccent, width: 3)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            (widget.imageURl == null || widget.imageURl.isEmpty)
                ? Text(
                    fileName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : fileName,
            Spacer(),
            InkWell(
              onTap: () async {
                // PickedFile image =
                //     await _imagePicker.getImage(source: ImageSource.gallery);
                // var name = image.path.split(Platform.pathSeparator).last;
                // setState(() {
                //   fileName = widget.documentName;
                // });
                // if (image != null) widget.onImagePicked(image.path);
              },
              child: Icon(
                _uploaded ? Icons.check_circle : LineAwesomeIcons.folder,
                color: _uploaded ? Colors.green : PrimaryColors.backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileUploadController {
  Function onUpload;
}
