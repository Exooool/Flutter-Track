import 'dart:ui';

import 'package:flutter/material.dart';

class BeforeLog extends StatefulWidget {
  BeforeLog({Key? key}) : super(key: key);

  @override
  State<BeforeLog> createState() => _BeforeLogState();
}

class _BeforeLogState extends State<BeforeLog> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  late Animation<double> opacityBackAnimation;
  late Animation<double> scaleHeightAnimation;
  bool isForward = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 12), vsync: this)
          ..addListener(() {
            setState(() {});
          });

    opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: const Interval(5.5 / 10, 6 / 10)));
    opacityBackAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: const Interval(6.5 / 10, 1)));
    scaleAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: const Interval(4 / 10, 6 / 10)));
    // scaleHeightAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
    //     parent: controller, curve: const Interval(4 / 10, 6 / 10)));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var cwidth = MediaQueryData.fromWindow(window).size.width;
    var cheight = MediaQueryData.fromWindow(window).size.height;

    return Visibility(
      visible: opacityBackAnimation.value == 0 ? false : true,
      child: Opacity(
        opacity: opacityBackAnimation.value,
        child: Container(
          color: const Color.fromRGBO(233, 238, 255, 1),
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Center(
              child: Container(
                color: const Color.fromRGBO(233, 238, 255, 1),
                width: cwidth * scaleAnimation.value,
                // height: cheight * scaleHeightAnimation.value,
                child: Image.asset(
                  'lib/assets/gifs/开屏.gif',
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
