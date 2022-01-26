import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color.fromRGBO(107, 101, 244, 1);
  static const blue = Color.fromRGBO(51, 84, 244, 1);
  // 16进制颜色值转换
  static Color string2Color(String colorString) {
    int? value = 0x00000000;
    if (colorString.isNotEmpty) {
      if (colorString[0] == '#') {
        colorString = colorString.substring(1);
      }
      value = int.tryParse(colorString, radix: 16);
      if (value != null) {
        if (value < 0xFF000000) {
          value += 0xFF000000;
        }
      }
    }
    return Color(value!);
  }
}
