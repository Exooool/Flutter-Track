import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';

class BlurWidget extends StatelessWidget {
  final Widget widget;
  const BlurWidget(this.widget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        // 切割很重要
        ClipRect(
          child: SizedBox(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.r)),
                    color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
        ),

        PublicCard(
            radius: 30.r,
            height: double.maxFinite,
            width: double.maxFinite,
            widget: widget),
      ],
    );
  }
}
