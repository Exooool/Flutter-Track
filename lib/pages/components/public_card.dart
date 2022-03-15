import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';

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

class PublicCard extends StatelessWidget {
  final Widget widget;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final bool notWhite;
  final Function()? onTap;
  const PublicCard(
      {Key? key,
      this.height,
      this.width,
      this.margin,
      this.padding,
      required this.radius,
      required this.widget,
      this.notWhite = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: margin,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              gradient: notWhite
                  ? MyWidgetStyle.mainLinearGradient
                  : MyWidgetStyle.secondLinearGradient),
          height: height,
          width: width,
          child: CustomPaint(
            painter: BorderGradientPainter(
                radius: radius,
                strokeWidth: 2,
                gradient: MyWidgetStyle.borderLinearGradient),
            child: Container(
              padding: padding,
              child: widget,
            ),
          )),
    );
  }
}
