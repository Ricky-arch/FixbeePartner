import 'package:flutter/material.dart';
import 'dart:math';

class CustomTimerPainter extends CustomPainter {
  double pi = 3.1415926535897932;
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
    this.width,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;
  final width;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), width, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
