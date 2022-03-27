import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';

import '../components/custom_appbar.dart';

class MatchGroup extends StatelessWidget {
  const MatchGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar('match',
            title: '匹配中',
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  'lib/assets/icons/Refund_back.png',
                  height: 25.r,
                  width: 25.r,
                ))),
        body: Column(
          children: <Widget>[
            Image.asset('lib/assets/gifs/匹配中.gif'),
            Text('正在匹配小组成员',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: MyFontSize.font16)),
            Text('匹配完成系统将提醒您进入',
                style: TextStyle(
                    fontSize: MyFontSize.font12, color: MyColor.fontGrey)),
            PublicCard(
                radius: 90.r,
                notWhite: true,
                onTap: () => Get.back(),
                margin: EdgeInsets.only(top: 42.h),
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 13.h, bottom: 13.h),
                widget: const Text(
                  '返回首页',
                  style: TextStyle(color: MyColor.fontWhite),
                ))
          ],
        ));
  }
}
