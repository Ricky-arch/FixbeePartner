import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;

class ImagePicker extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.yellow[900],
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 75,
            backgroundImage: (_image != null)
                ? FileImage(_image)
                : NetworkImage(
                    "https://image.flaticon.com/icons/png/128/1077/1077012.png",
                  ),
          ),
          Positioned(
            bottom: -1,
            right: -10,
            child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 28,
                color: Colors.black,
              ),
              onPressed: (){
                getImage();
              },
            ),
          )
        ],
      ),
    );
  }

  Future getImage() async {
    File image =
        await img.ImagePicker.pickImage(source: img.ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}
