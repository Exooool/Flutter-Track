import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class MyColor {
  static const Color fontWhite = Color.fromRGBO(240, 242, 243, 1);
  static const Color fontWhiteO5 = Color.fromRGBO(240, 242, 243, 0.5);
  static const Color fontWhiteO8 = Color.fromRGBO(240, 242, 243, 0.8);
  static const Color fontBlack = Color.fromRGBO(0, 0, 0, 1);
  static const Color fontBlackO2 = Color.fromRGBO(0, 0, 0, 0.2);
  static const Color fontGrey = Color.fromRGBO(158, 158, 158, 1);
  static const Color mainColor = Color.fromRGBO(107, 101, 244, 1);
  static const Color secondColor = Color.fromRGBO(51, 84, 244, 1);
  static const Color mainColorO4 = Color.fromRGBO(107, 101, 244, 0.4);
  static const Color secondColorO4 = Color.fromRGBO(51, 84, 244, 0.4);
  static const Color thirdColor = Color.fromRGBO(78, 92, 244, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color whiteO5 = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color transparent = Color.fromRGBO(255, 255, 255, 0);
}

class MyFontSize {
  static double font32 = 32.sp;
  static double font30 = 30.sp;
  static double font26 = 26.sp;
  static double font22 = 22.sp;
  static double font20 = 20.sp;
  static double font19 = 19.sp;
  static double font18 = 18.sp;
  static double font16 = 16.sp;
  static double font14 = 14.sp;
  static double font12 = 12.sp;
  static double font10 = 10.sp;
  static double font9 = 9.sp;
}

class MyFontStyle {
  static TextStyle projectTabUnSelected = TextStyle(
      fontSize: MyFontSize.font14,
      foreground: MyFontStyle.textlinearForeground);
  static TextStyle projectTabSelected =
      TextStyle(fontSize: MyFontSize.font14, color: MyColor.fontWhite);
  // 数据页 排行榜标题
  static TextStyle rankTitle = TextStyle(
      fontWeight: FontWeight.w700,
      color: MyColor.fontWhite,
      fontSize: MyFontSize.font19);
  // 数据页 排行榜用户
  static TextStyle rankUser = TextStyle(
      fontWeight: FontWeight.w600,
      color: MyColor.fontWhite,
      fontSize: MyFontSize.font12);
  // 数据页 排行榜学校
  static TextStyle rankSchool = TextStyle(
      fontWeight: FontWeight.w600,
      color: MyColor.fontWhite,
      fontSize: MyFontSize.font12);

  static Paint textlinearForeground = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(0, 10),
      const Offset(1, 30),
      <Color>[
        const Color.fromRGBO(107, 101, 244, 1),
        const Color.fromRGBO(51, 84, 244, 1)
      ],
    );
  static Paint textlinearForegroundO5 = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(0, 10),
      const Offset(1, 30),
      <Color>[
        const Color.fromRGBO(107, 101, 244, 0.5),
        const Color.fromRGBO(51, 84, 244, 0.5)
      ],
    );
}

class MyWidgetStyle {
  // 两种主题色的线性渐变 用于计划卡片
  static const LinearGradient mainLinearGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyColor.mainColor, MyColor.secondColor]);

  static const LinearGradient mainLinearGradientO4 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyColor.mainColorO4, MyColor.secondColorO4]);

  // 白色透明渐变
  static const LinearGradient secondLinearGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.01, 0.99],
      colors: [MyColor.whiteO5, MyColor.transparent]);
  // 白色透明渐变边框
  static const LinearGradient borderLinearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.1,
        0.6,
        1
      ],
      colors: [
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 0),
        Color.fromRGBO(255, 255, 255, 0.77)
      ]);

  // 盒子或卡片背景阴影 用于计划卡片
  static const BoxShadow mainBoxShadow = BoxShadow(
    color: Color.fromRGBO(56, 86, 244, 0.4), // 阴影的颜色
    offset: Offset(0, 6), // 阴影与容器的距离
    blurRadius: 10, // 高斯的标准偏差与盒子的形状卷积。
    spreadRadius: 0, // 在应用模糊之前，框应该膨胀的量。
  );
}
