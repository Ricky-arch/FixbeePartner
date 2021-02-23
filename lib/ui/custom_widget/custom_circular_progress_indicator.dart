import 'package:flutter/material.dart';
import '../../Constants.dart';
class CustomCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor:
      AlwaysStoppedAnimation<Color>(
          Colors.white),
      backgroundColor:
      PrimaryColors.backgroundColor,
    );
  }
}
