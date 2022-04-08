import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/project/project_controller.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

import '../components/custom_appbar.dart';

class MatchGroupController extends GetxController {
  final Map info = Get.arguments;
  match() {
    DioUtil().post('/project/group/add', data: {
      'project_id': info['project_id'],
      'frequency': info['frequency']
    }, success: (res) {
      debugPrint('$res');

      // 没有可以匹配的小组时 转为自动创建小组进行匹配
      if (res['status'] == 2) {
        debugPrint('没有可匹配的小组，创建小组');
        //
        DioUtil().post('/project/group/create', data: {
          'project_id': info['project_id'],
          'frequency': info['frequency']
        }, success: (res) {
          print(res);
        }, error: (error) {
          print(error);
        });
      }
    }, error: (error) {
      print(error);
    });
  }

  @override
  void onInit() {
    super.onInit();
    // 匹配
    match();
  }
}

class MatchGroup extends StatelessWidget {
  MatchGroup({Key? key}) : super(key: key);
  final MatchGroupController c = Get.put(MatchGroupController());
  final ProjectController p = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar('match',
            title: '匹配中',
            leading: InkWell(
                onTap: () {
                  Get.back();
                  p.getInfo();
                },
                child: Image.asset(
                  'lib/assets/icons/Refund_back.png',
                  height: 25.r,
                  width: 25.r,
                ))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/gifs/匹配中.gif',
              width: MediaQueryData.fromWindow(window).size.width,
              fit: BoxFit.cover,
            ),
            Text('正在匹配小组成员',
                style: TextStyle(
                    fontFamily: MyFontFamily.pingfangMedium,
                    fontSize: MyFontSize.font16)),
            Text('匹配完成系统将提醒您进入',
                style: TextStyle(
                    fontFamily: MyFontFamily.pingfangRegular,
                    fontSize: MyFontSize.font12,
                    color: MyColor.fontGrey)),
            PublicCard(
                radius: 90.r,
                notWhite: true,
                onTap: () {
                  Get.back();
                  p.getInfo();
                },
                margin: EdgeInsets.only(top: 42.h),
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 13.h, bottom: 13.h),
                widget: Text(
                  '返回首页',
                  style: TextStyle(
                      color: MyColor.fontWhite,
                      fontFamily: MyFontFamily.pingfangSemibold,
                      fontSize: MyFontSize.font16),
                ))
          ],
        ));
  }
}
