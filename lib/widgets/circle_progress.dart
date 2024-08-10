import 'package:flutter/material.dart';
import 'dart:math' as math;



class CustomCircleWidget extends CustomPainter{

double right = 250;
double bottom = 250;
late Color color;
late double rad;


CustomCircleWidget(this.color, this.rad) {  
  color = color;
  rad   = rad;  
  
}


@override
void paint(Canvas canvas, Size size){

  final rec = Rect.fromLTRB(0, 0, right, bottom);
  final startAngle = math.pi * rad; 
  const sweepAngle = math.pi / 3;
  const useCenter = false;
  
  final paint = Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 15;

  canvas.drawArc(rec, startAngle, sweepAngle, useCenter, paint);

}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {   
    return true;
  }





}