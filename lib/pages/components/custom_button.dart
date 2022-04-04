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

class CustomButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double? height;
  final double? width;
  final double? fontSize;
  final Widget? child;
  final EdgeInsetsGeometry margin;
  final bool shadow;
  const CustomButton(
      {Key? key,
      this.title = '',
      required this.onPressed,
      this.height,
      this.width,
      this.child,
      this.fontSize = 16,
      this.margin = const EdgeInsets.all(20),
      this.shadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(107, 101, 244, 1),
                  Color.fromRGBO(51, 84, 244, 1)
                ])),
        margin: margin,
        width: width,
        height: height,
        child: CustomPaint(
          painter: BorderGradientPainter(
              radius: 30.r,
              strokeWidth: 2,
              gradient: MyWidgetStyle.borderLinearGradient),
          child: ElevatedButton(
            style: ButtonStyle(
                // 去除自身的背景色和阴影
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0)),
            child: child ??
                Text(title,
                    style: TextStyle(
                        fontSize: fontSize, color: MyColor.fontWhite)),
            onPressed: onPressed,
          ),
        ));
  }
}
