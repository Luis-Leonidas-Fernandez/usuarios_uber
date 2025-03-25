import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomCircleWidget extends CustomPainter {
  final Color color;
  final double rad;
  final double right;
  final double bottom;

  CustomCircleWidget(this.color, this.rad, {this.right = 250, this.bottom = 250});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, right, bottom);
    final startAngle = math.pi * rad;
    const sweepAngle = math.pi / 3;
    const useCenter = false;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomCircleWidget oldDelegate) {
    return oldDelegate.color != color ||
           oldDelegate.rad != rad ||
           oldDelegate.right != right ||
           oldDelegate.bottom != bottom;
  }
}
