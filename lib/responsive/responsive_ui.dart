import 'package:flutter/material.dart';
import 'dart:math';

class ResponsiveUtil {

  final BuildContext context;
  final double screenWidth;
  final double screenHeight;
  final double textScaleFactor;

  ResponsiveUtil(this.context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height,
        textScaleFactor = sqrt(MediaQuery.of(context).size.width * MediaQuery.of(context).size.width +
            MediaQuery.of(context).size.height * MediaQuery.of(context).size.height) / 1.5;

  double getResponsiveFontSize(double baseFontSize) {
   
    return textScaleFactor / baseFontSize;
  }

  double getResponsiveWidth(double baseWidth) {
    return baseWidth * screenWidth;
  }

  double getResponsiveHeight(double baseHeight) {
    return baseHeight * screenHeight;
  }
}