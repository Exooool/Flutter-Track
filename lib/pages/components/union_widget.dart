import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';

// class Cliper extends CustomClipper<Path> {
//   // 通过计算字体的个数来切割
//   late final double width;

//   Cliper(int length) {
//     width = length * 16.sp;
//   }
//   @override
//   Path getClip(Size size) {
//     double round1 = 20.r;
//     double round2 = 10.r;
//     Path path = Path();

//     path.moveTo(size.width, size.height);

//     path.lineTo(0, size.height);

//     path.lineTo(0, 0);

//     // 第一个贝塞尔曲线起点
//     double firstStart = 48.w + width - round1;

//     path.lineTo(firstStart, 0);

//     // 第一个贝塞尔曲线控制点
//     double controll1 = 48.w + width;
//     // 突出的部分的右上圆角进行贝塞尔
//     path.quadraticBezierTo(controll1, 0, controll1, round1);

//     path.lineTo(controll1, round1 + 10.r);
//     // 突出的部分的右下圆角进行贝塞尔
//     path.quadraticBezierTo(controll1, round1 + round2 + 10.r,
//         controll1 + round2, round1 + round2 + 10);

//     path.lineTo(size.width - round1, round1 + round2 + 10.r);

//     path.quadraticBezierTo(size.width, round1 + round2 + 10.r, size.width,
//         round1 * 2 + round2 + 10.r);
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

class UionPainter extends CustomPainter {
  final Paint _paint = Paint();
  final Paint _paint2 = Paint();
  // 通过计算字体的个数来切割
  late final double width;
  late final int index;

  final strokeWidth = 2.0;
  final strokeMargin = 2.0 / 2;
  final addHeight = 5.h;

  UionPainter(int length, {this.index = 0}) {
    width = length * 16.sp;
  }
  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..style = PaintingStyle.fill
      ..color = Colors.green;

    // uion渐变填充
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    _paint.shader = MyWidgetStyle.secondLinearGradient.createShader(rect);

    double round1 = 20.r;
    double round2 = 10.r;
    Path path = Path();
    // 画背景板
    // 右下角贝塞尔
    path.moveTo(size.width, size.height - round1);
    path.quadraticBezierTo(
        size.width, size.height, size.width - round1, size.height);
    // 左下角贝塞尔
    path.lineTo(round1, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - round1);
    // 第一个贝塞尔曲线起点
    double firstStart = 48.w + width - round1;
    // 第一个贝塞尔曲线控制点
    double controll1 = 48.w + width;
    double secondStart = size.width / 2 + 24.w + 32.sp - round1;
    // 0是第一个
    if (index == 0) {
      // 左上角贝塞尔
      path.lineTo(0, round1);
      path.quadraticBezierTo(0, 0, round1, 0);

      path.lineTo(firstStart, 0);

      // 突出的部分的右上圆角进行贝塞尔
      path.quadraticBezierTo(controll1, 0, controll1, round1);
      // 突出的部分的右下圆角进行贝塞尔
      path.lineTo(controll1, round1 + round2 + addHeight);
      path.quadraticBezierTo(controll1, round1 + round2 * 2 + addHeight,
          controll1 + round2, round1 + round2 * 2 + addHeight);
      //
      path.lineTo(size.width - round1, round1 + round2 * 2 + addHeight);
      path.quadraticBezierTo(size.width, round1 + round2 * 2 + addHeight,
          size.width, round1 * 2 + round2 * 2 + addHeight);
    } else if (index == 1) {
      // 左上角
      path.lineTo(0, round1 * 2 + round2 * 2 + addHeight);
      path.quadraticBezierTo(0, round1 + round2 * 2 + addHeight, round1,
          round1 + round2 * 2 + addHeight);

      // 突出部分左下角
      firstStart = size.width / 2 - 24.w - 32.sp - round2;
      path.lineTo(firstStart, round1 + round2 * 2 + addHeight);
      path.quadraticBezierTo(
          firstStart + round2,
          round1 + round2 * 2 + addHeight,
          firstStart + round2,
          round1 + round2 + addHeight);

      // 突出部分左上角
      path.lineTo(firstStart + round2, round1);
      path.quadraticBezierTo(
          firstStart + round2, 0, firstStart + round2 + round1, 0);

      // double secondStart = size.width / 2 + 24.w + 32.sp - round1;
      // 突出部分右上角
      path.lineTo(secondStart, 0);
      path.quadraticBezierTo(
          secondStart + round1, 0, secondStart + round1, round1);

      // 突出部分右下角
      path.lineTo(secondStart + round1, round1 + round2 + addHeight);
      path.quadraticBezierTo(
          secondStart + round1,
          round1 + round2 * 2 + addHeight,
          secondStart + round1 + round2,
          round1 + round2 * 2 + addHeight);
      //
      path.lineTo(size.width - round1, round1 + round2 * 2 + addHeight);
      path.quadraticBezierTo(size.width, round1 + round2 * 2 + addHeight,
          size.width, round1 * 2 + round2 * 2 + addHeight);
    } else {
      // 左上角
      path.lineTo(0, round1 * 2 + round2 * 2 + addHeight);
      path.quadraticBezierTo(0, round1 + round2 * 2 + addHeight, round1,
          round1 + round2 * 2 + addHeight);

      firstStart = size.width - 48.w - width - round2;
      // 突出部分左下角
      path.lineTo(firstStart, round1 + round2 * 2 + addHeight);
      path.quadraticBezierTo(
          firstStart + round2,
          round1 + round2 * 2 + addHeight,
          firstStart + round2,
          round1 + round2 + addHeight);
      // 突出部分左上角
      path.lineTo(firstStart + round2, round1);
      path.quadraticBezierTo(
          firstStart + round2, 0, firstStart + round2 + round1, 0);

      // 突出部分右上角
      path.lineTo(size.width - round1, 0);
      path.quadraticBezierTo(size.width, 0, size.width, round1);
    }

    // path.lineTo(200, 200);
    canvas.drawPath(path, _paint);

    // 画边框
    var borderPath = Path();
    _paint2.color = Colors.black;
    _paint2.strokeWidth = strokeWidth;

    // 边框渐变填充
    Rect rectlinaer = Rect.fromLTWH(0, 0, size.width, size.height);
    _paint2.shader =
        MyWidgetStyle.borderLinearGradient.createShader(rectlinaer);

    // 右下角
    borderPath.moveTo(size.width - strokeMargin, size.height - round1);

    borderPath.quadraticBezierTo(size.width - strokeMargin, size.height,
        size.width - strokeMargin - round1, size.height - strokeMargin);
    // 左下角
    borderPath.lineTo(round1, size.height - strokeMargin);

    borderPath.quadraticBezierTo(strokeMargin, size.height - strokeMargin,
        strokeMargin, size.height - strokeMargin - round1);

    if (index == 0) {
      // 左上角
      borderPath.lineTo(strokeMargin, strokeMargin + round1);

      borderPath.quadraticBezierTo(
          strokeMargin, strokeMargin, strokeMargin + round1, strokeMargin);

      // 突出上
      borderPath.lineTo(firstStart + strokeMargin, strokeMargin);
      borderPath.quadraticBezierTo(
          firstStart - strokeMargin + round1,
          strokeMargin,
          firstStart - strokeMargin + round1,
          strokeMargin + round1);

      // 突出下
      borderPath.lineTo(firstStart - strokeMargin + round1,
          strokeMargin + round1 + round2 + addHeight);
      borderPath.quadraticBezierTo(
          firstStart - strokeMargin + round1,
          strokeMargin + round1 + round2 * 2 + addHeight,
          firstStart - strokeMargin + round1 + round2,
          strokeMargin + round1 + round2 * 2 + addHeight);

      // 右上角
      borderPath.lineTo(size.width - strokeMargin - round1,
          strokeMargin + round1 + round2 * 2 + addHeight);
      borderPath.quadraticBezierTo(
          size.width - strokeMargin,
          strokeMargin + round1 + round2 * 2 + addHeight,
          size.width - strokeMargin,
          strokeMargin + round1 * 2 + round2 * 2 + addHeight);
    } else if (index == 1) {
      //左上角
      borderPath.lineTo(
          strokeMargin, strokeMargin + round1 * 2 + round2 * 2 + addHeight);
      borderPath.quadraticBezierTo(
          strokeMargin,
          round1 + round2 * 2 + addHeight + strokeMargin,
          strokeMargin + round1,
          round1 + round2 * 2 + addHeight + strokeMargin);

      // 突出部分左下角
      borderPath.lineTo(firstStart + strokeMargin,
          round1 + round2 * 2 + addHeight + strokeMargin);
      borderPath.quadraticBezierTo(
          firstStart + strokeMargin + round2,
          round1 + round2 * 2 + addHeight + strokeMargin,
          firstStart + strokeMargin + round2,
          round1 + round2 + addHeight + strokeMargin);

      // 突出部分左上角
      borderPath.lineTo(
          firstStart + strokeMargin + round2, round1 + strokeMargin);
      borderPath.quadraticBezierTo(
          firstStart + strokeMargin + round2,
          strokeMargin,
          firstStart + strokeMargin + round2 + round1,
          strokeMargin);

      // 突出部分右上角
      borderPath.lineTo(secondStart - strokeMargin, strokeMargin);
      borderPath.quadraticBezierTo(
          secondStart - strokeMargin + round1,
          strokeMargin,
          secondStart - strokeMargin + round1,
          strokeMargin + round1);

      // 突出部分右下角
      borderPath.lineTo(
          secondStart - strokeMargin + round1, strokeMargin + round1 + round2);
      borderPath.quadraticBezierTo(
          secondStart - strokeMargin + round1,
          strokeMargin + round1 + round2 * 2 + addHeight,
          secondStart - strokeMargin + round1 + round2,
          strokeMargin + round1 + round2 * 2 + addHeight);
      // 右上角

      borderPath.lineTo(size.width - strokeMargin - round1,
          strokeMargin + round1 + round2 * 2 + addHeight);
      borderPath.quadraticBezierTo(
          size.width - strokeMargin,
          strokeMargin + round1 + round2 * 2 + addHeight,
          size.width - strokeMargin,
          strokeMargin + round1 * 2 + round2 * 2 + addHeight);
    } else {
      //左上角
      borderPath.lineTo(
          strokeMargin, strokeMargin + round1 * 2 + round2 * 2 + addHeight);
      borderPath.quadraticBezierTo(
          strokeMargin,
          round1 + round2 * 2 + addHeight + strokeMargin,
          strokeMargin + round1,
          round1 + round2 * 2 + addHeight + strokeMargin);

      // 突出部分左下角
      borderPath.lineTo(
          firstStart + strokeMargin, round1 + round2 * 2 + addHeight);
      borderPath.quadraticBezierTo(
          firstStart + round2 + strokeMargin,
          round1 + round2 * 2 + addHeight,
          firstStart + round2 + strokeMargin,
          round1 + round2 + addHeight);

      // 突出部分左上角
      borderPath.lineTo(
          firstStart + round2 + strokeMargin, round1 + strokeMargin);
      borderPath.quadraticBezierTo(
          firstStart + round2 + strokeMargin,
          strokeMargin,
          firstStart + round2 + strokeMargin + round1,
          strokeMargin);

      // 突出右上角
      borderPath.lineTo(size.width - strokeMargin - round1, strokeMargin);
      borderPath.quadraticBezierTo(size.width - strokeMargin, strokeMargin,
          size.width - strokeMargin, strokeMargin + round1);
    }

    // 路径闭合
    borderPath.lineTo(size.width - strokeMargin, size.height - round1);

    _paint2.style = PaintingStyle.stroke;

    canvas.drawPath(borderPath, _paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class UnionWidget extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final int? index;
  final double height;
  final List<String>? subTitle;
  final Function()? onTapOne;
  final Function()? onTapTwo;
  final Function()? onTapThree;
  const UnionWidget({
    Key? key,
    required this.children,
    required this.title,
    this.index,
    required this.height,
    this.subTitle,
    this.onTapOne,
    this.onTapTwo,
    this.onTapThree,
  }) : super(key: key);

  // 小选项按钮
  Widget gradientBox(String title, bool show, Function()? onTap) {
    return PublicCard(
        radius: 90.r,
        onTap: onTap,
        margin: EdgeInsets.only(left: 13.w),
        // padding:
        //     EdgeInsets.only(left: 23.w, right: 23.w, top: 3.h, bottom: 3.h),
        height: 24.h,
        width: 60.w,
        widget: Center(
          child: Opacity(
            opacity: show ? 1 : 0.2,
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: MyFontFamily.pingfangMedium,
                  fontSize: MyFontSize.font14,
                  color: MyColor.fontBlack),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: UionPainter(title.length),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 9.h, left: 24.w, right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 9.h),
                child: subTitle == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: 24.w),
                              child: Text(
                                title,
                                style: TextStyle(
                                    color: MyColor.fontBlack,
                                    fontFamily: MyFontFamily.pingfangSemibold,
                                    fontSize: MyFontSize.font16),
                              )),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 24.w),
                              child: Text(
                                title,
                                style: TextStyle(
                                    color: MyColor.fontBlack,
                                    fontFamily: MyFontFamily.pingfangSemibold,
                                    fontSize: MyFontSize.font16),
                              )),
                          Row(
                            children: <Widget>[
                              gradientBox(subTitle![0],
                                  index == 0 ? true : false, onTapOne),
                              gradientBox(subTitle![1],
                                  index == 1 ? true : false, onTapTwo),
                              gradientBox(subTitle![2],
                                  index == 2 ? true : false, onTapThree)
                            ],
                          )
                        ],
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              )
            ],
          ),
        )
      ],
    );
  }
}

class UnionTabView extends StatelessWidget {
  final double height;
  final List<String> title;
  final List<Widget> children;
  final int index;
  const UnionTabView(
      {Key? key,
      required this.height,
      required this.title,
      required this.children,
      this.index = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: UionPainter(title[index].length, index: index),
          ),
        ),
        Column(
          children: children,
        )
      ],
    );
  }
}
