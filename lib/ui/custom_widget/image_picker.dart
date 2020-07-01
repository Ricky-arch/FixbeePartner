import 'dart:io';

import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;

class ImagePicker extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  dynamic _image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 80,
      child: GestureDetector(
        onTap: () {
          getImage();
        },
        child: (_image != null)
            ? FileImage(_image)
            : Stack(
                children: [
                  Image.asset(
                    "assets/custom_icons/bee.png",
                    height: 80,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: 50,
                    bottom: 0,
                    child: Icon(Icons.add_a_photo, color: Colors.orange,),
                  )
                ],
              ),
      ),
      decoration: BoxDecoration(
        color: PrimaryColors.backgroundColor,
        shape: BoxShape.circle,

      ),
    );
  }

  Future getImage() async {
    var image =
        await img.ImagePicker.pickImage(source: img.ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}
