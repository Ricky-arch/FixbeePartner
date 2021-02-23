
import 'package:fixbee_partner/animations/clip_design/custom_shadow.dart';
import 'package:fixbee_partner/animations/clip_design/message_clipper.dart';
import 'package:flutter/material.dart';
class Message extends StatelessWidget {
  const Message(
      {Key key,
        @required this.triangleX1,
        @required this.triangleX2,
        @required this.triangleX3,
        @required this.triangleY1,
        this.child,
        this.clipShadows = const []})
      : super(key: key);

  ///The left corner distance of triangle to widget's left edge
  final double triangleX1;

  ///The right corner distance of triangle to widget's left edge
  final double triangleX2;

  ///The point corner distance of triangle to widget's left edge
  final double triangleX3;

  ///The message box height
  final double triangleY1;

  final Widget child;

  ///List of shadows to be cast on the border
  final List<ClipShadow> clipShadows;

  @override
  Widget build(BuildContext context) {
    var clipper =
    MessageClipper(triangleX1, triangleX2, triangleX3, triangleY1);
    return CustomPaint(
      painter: ClipShadowPainter(clipper, clipShadows),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}