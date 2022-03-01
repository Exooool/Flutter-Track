import 'package:flutter/material.dart';
import 'dart:ui';

class ScreenFit {
  static MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
  static double standardWidth = 750;
  static late double screenWidth = mediaQueryData.size.width;
  static late double screenHeight = mediaQueryData.size.height;
  static late double rpx = screenWidth / standardWidth;
  static late double px = screenWidth / standardWidth * 2;

  // 按照像素来设置
  static double setPx(double size) {
    return ScreenFit.rpx * size * 2;
  }

  // 按照rxp来设置
  static double setRpx(double size) {
    return ScreenFit.rpx * size;
  }
}
