import 'package:flutter/material.dart';
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
  static double font32 = 32;
  static double font30 = 30;
  static double font28 = 28;
  static double font26 = 26;
  static double font22 = 22;
  static double font20 = 20;
  static double font19 = 19;
  static double font18 = 18;
  static double font16 = 16;
  static double font14 = 14;
  static double font12 = 12;
  static double font10 = 10;
  static double font9 = 9;
}

class MyFontFamily {
  static String pingfangRegular = 'PingFangRegular';
  static String pingfangMedium = 'PingFangMedium';
  static String pingfangSemibold = 'PingFangSemibold';
  static String sfDisplaySemibold = 'SFDisplaySemibold';
  static String sfDisplayBold = 'SFDisplayBold';
  static String sfDisplayRegular = 'SFDisplayRegular';
}

class MyFontStyle {
  static TextStyle projectTabUnSelected = TextStyle(
      fontSize: MyFontSize.font16,
      fontFamily: MyFontFamily.pingfangRegular,
      foreground: MyFontStyle.textlinearForeground);
  static TextStyle projectTabSelected = TextStyle(
      fontSize: MyFontSize.font16,
      fontFamily: MyFontFamily.pingfangRegular,
      color: MyColor.fontWhite);
  // ????????? ???????????????
  static TextStyle rankTitle = TextStyle(
      fontFamily: MyFontFamily.sfDisplayBold,
      color: MyColor.fontBlack,
      fontSize: MyFontSize.font19);
  // ????????? ???????????????
  static TextStyle rankUser = TextStyle(
      fontFamily: MyFontFamily.pingfangSemibold,
      color: MyColor.fontBlack,
      fontSize: MyFontSize.font12);
  // ????????? ???????????????
  static TextStyle rankSchool = TextStyle(
      fontFamily: MyFontFamily.pingfangSemibold,
      color: MyColor.fontBlack,
      fontSize: MyFontSize.font12);

  static Paint textlinearForeground = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(0, 10),
      const Offset(1, 30),
      <Color>[
        const Color.fromRGBO(107, 101, 244, 1),
        const Color.fromRGBO(51, 84, 244, 1),
      ],
    );
  static Paint textlinearForegroundO2 = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(0, 10),
      const Offset(1, 30),
      <Color>[
        const Color.fromRGBO(107, 101, 244, 0.2),
        const Color.fromRGBO(51, 84, 244, 0.2)
      ],
    );
}

class MyWidgetStyle {
  // ?????????????????????????????? ??????????????????
  static const LinearGradient mainLinearGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyColor.mainColor, MyColor.secondColor]);

  static const LinearGradient mainLinearGradientO4 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyColor.mainColorO4, MyColor.secondColorO4]);

  // ??????????????????
  static const LinearGradient secondLinearGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.01, 0.99],
      colors: [MyColor.whiteO5, MyColor.transparent]);

  // ????????????????????????
  static const LinearGradient borderLinearGradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      stops: [
        0.1,
        0.5,
        1
      ],
      colors: [
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 0),
        Color.fromRGBO(255, 255, 255, 0.77)
      ]);

  // ??????????????????????????? ??????????????????
  static const BoxShadow mainBoxShadow = BoxShadow(
    color: Color.fromRGBO(56, 86, 244, 0.4), // ???????????????
    offset: Offset(0, 6), // ????????????????????????
    blurRadius: 10, // ????????????????????????????????????????????????
    spreadRadius: 0, // ????????????????????????????????????????????????
  );
}

class BorderGradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  BorderGradientPainter(
      {required this.radius,
      required this.strokeWidth,
      required this.gradient});
  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

const Map<String, Color> tfColor = {
  "fColor1": Color.fromRGBO(255, 128, 128, 1),
  "fColor2": Color.fromRGBO(255, 191, 128, 1),
  "fColor3": Color.fromRGBO(255, 255, 128, 1),
  "fColor4": Color.fromRGBO(191, 255, 128, 1),
  "fColor5": Color.fromRGBO(128, 255, 128, 1),
  "fColor6": Color.fromRGBO(128, 255, 191, 1),
  "fColor7": Color.fromRGBO(128, 255, 255, 1),
  "fColor8": Color.fromRGBO(128, 191, 255, 1),
  "fColor9": Color.fromRGBO(128, 128, 255, 1),
  "fColor10": Color.fromRGBO(191, 128, 255, 1),
  "fColor11": Color.fromRGBO(255, 128, 255, 1),
  "fColor12": Color.fromRGBO(255, 128, 191, 1),
  "fColor13": Color.fromRGBO(0, 0, 0, 1),
  "fColor14": Color.fromRGBO(255, 255, 255, 1),
};
