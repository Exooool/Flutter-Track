import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cliper extends CustomClipper<Path> {
  final bool small;
  final double widthThree = 3 * 16.sp;
  final double widthFour = 4 * 16.sp;
  Cliper(this.small);
  @override
  Path getClip(Size size) {
    double round1 = 20.r;
    double round2 = 10.r;
    Path path = Path();

    path.moveTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.lineTo(0, 0);

    // 第一个贝塞尔曲线起点
    double firstStart = 48.w + (small ? widthThree : widthFour) - round1;

    path.lineTo(firstStart, 0);

    // 第一个贝塞尔曲线控制点
    double controll1 = 48.w + (small ? widthThree : widthFour);
    // 突出的部分的右上圆角进行贝塞尔
    path.quadraticBezierTo(controll1, 0, controll1, round1);

    path.lineTo(controll1, round1 + 10);
    // 突出的部分的右下圆角进行贝塞尔
    path.quadraticBezierTo(controll1, round1 + round2 + 10, controll1 + round2,
        round1 + round2 + 10);

    path.lineTo(size.width - round1, round1 + round2 + 10);

    path.quadraticBezierTo(
        size.width, round1 + round2 + 10, size.width, round1 * 2 + round2 + 10);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class UnionWidget extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final bool small;
  final double height;
  final List<String> subTitle;
  final Function()? onTapOne;
  final Function()? onTapTwo;
  final Function()? onTapThree;
  const UnionWidget({
    Key? key,
    required this.children,
    required this.title,
    required this.small,
    required this.height,
    required this.subTitle,
    this.onTapOne,
    this.onTapTwo,
    this.onTapThree,
  }) : super(key: key);

  Widget gradientBox(String title, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 24.h,
        width: 60.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(107, 101, 244, 1),
                  Color.fromRGBO(51, 84, 244, 1)
                ])),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 14.sp, color: const Color.fromRGBO(240, 242, 243, 1)),
        ),
      ),
    );
  }

  ClipPath unionBg() {
    return ClipPath(
      clipper: Cliper(small),
      child: Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(107, 101, 244, 1),
                  Color.fromRGBO(51, 84, 244, 1)
                ])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        unionBg(),
        Container(
          padding: EdgeInsets.only(top: 9.h, left: 24.w, right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 9.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 30.w),
                        child: Text(
                          title,
                          style: TextStyle(
                              color: const Color.fromRGBO(240, 242, 243, 1),
                              fontSize: 16.sp),
                        )),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        gradientBox(subTitle[0], onTapOne),
                        gradientBox(subTitle[1], onTapTwo),
                        gradientBox(subTitle[2], onTapThree),
                      ],
                    ))
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
