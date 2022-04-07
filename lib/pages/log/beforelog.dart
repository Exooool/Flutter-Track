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
  bool isForward = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 7), vsync: this)
          ..addListener(() {
            setState(() {});
          });

    opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: const Interval(5.8 / 6, 1)));
    scaleAnimation = Tween(begin: 1.0, end: 0.65).animate(CurvedAnimation(
        parent: controller, curve: const Interval(4.8 / 6, 5.8 / 6)));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var cwidth = MediaQueryData.fromWindow(window).size.width;

    return Visibility(
      visible: opacityAnimation.value == 0 ? false : true,
      child: Center(
        child: Opacity(
          opacity: opacityAnimation.value,
          child: Container(
            color: const Color.fromRGBO(233, 238, 255, 1),
            width: cwidth * scaleAnimation.value,
            child: Image.asset(
              'lib/assets/gifs/开屏.gif',
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
