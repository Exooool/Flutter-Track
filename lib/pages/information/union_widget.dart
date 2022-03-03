import 'package:flutter/material.dart';

class Cliper extends CustomClipper<Path> {
  // 通过计算字体的个数来切割
  late final double width;

  Cliper(int length) {
    width = length * 16;
  }
  @override
  Path getClip(Size size) {
    double round1 = 20;
    double round2 = 10;
    Path path = Path();

    path.moveTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.lineTo(0, 0);

    // 第一个贝塞尔曲线起点
    double firstStart = 48 + width - round1;

    path.lineTo(firstStart, 0);

    // 第一个贝塞尔曲线控制点
    double controll1 = 48 + width;
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
  final int index;
  final double height;
  final List<String> subTitle;
  final Function()? onTapOne;
  final Function()? onTapTwo;
  final Function()? onTapThree;
  const UnionWidget({
    Key? key,
    required this.children,
    required this.title,
    required this.index,
    required this.height,
    required this.subTitle,
    this.onTapOne,
    this.onTapTwo,
    this.onTapThree,
  }) : super(key: key);

  // 小选项按钮
  Widget gradientBox(String title, bool show, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: show ? 1 : 0.5,
        child: Container(
          height: 24,
          width: 60,
          margin: const EdgeInsets.only(left: 13),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(107, 101, 244, 1),
                    Color.fromRGBO(51, 84, 244, 1)
                  ])),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 14, color: Color.fromRGBO(240, 242, 243, 1)),
          ),
        ),
      ),
    );
  }

  ClipPath unionBg() {
    return ClipPath(
      clipper: Cliper(title.length),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
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
          padding: const EdgeInsets.only(top: 9, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 24),
                        child: Text(
                          title,
                          style: const TextStyle(
                              color: Color.fromRGBO(240, 242, 243, 1),
                              fontSize: 16),
                        )),
                    gradientBox(
                        subTitle[0], index == 0 ? true : false, onTapOne),
                    gradientBox(
                        subTitle[1], index == 1 ? true : false, onTapTwo),
                    gradientBox(
                        subTitle[2], index == 2 ? true : false, onTapThree)
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
