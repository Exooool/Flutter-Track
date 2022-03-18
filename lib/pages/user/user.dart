import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/assets/test.dart';

import 'package:flutter_track/pages/components/custom_appbar.dart';

// 样式导入
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_button.dart';

import 'package:flutter_track/pages/components/two_layer_tab.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);
  final UserController c = Get.put(UserController());

  // // 关注、粉丝按钮
  // Widget smallButton(String title, int nums, Function() onPressed) {
  //   return CustomButton(
  //       margin: const EdgeInsets.only(left: 12),
  //       shadow: false,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(title,
  //               style: TextStyle(
  //                   height: 1,
  //                   color: MyColor.fontWhite,
  //                   fontSize: MyFontSize.font12)),
  //           Container(
  //             margin: const EdgeInsets.only(left: 4, right: 4),
  //             decoration: const BoxDecoration(
  //                 color: MyColor.fontWhiteO5,
  //                 borderRadius: BorderRadius.all(Radius.circular(20))),
  //             width: 1,
  //             height: 14,
  //           ),
  //           Text('$nums',
  //               style: TextStyle(
  //                   height: 1,
  //                   color: MyColor.fontWhite,
  //                   fontSize: MyFontSize.font12))
  //         ],
  //       ),
  //       height: 24,
  //       width: 59,
  //       onPressed: onPressed);
  // }

  // 侧边按钮
  Widget slideButton(String title, Function() onPressed) {
    return CustomButton(
        title: title,
        shadow: false,
        height: 24.h,
        width: 80.w,
        margin: EdgeInsets.only(top: 14.h, bottom: 12.h, left: 6.w, right: 6.w),
        fontSize: MyFontSize.font14,
        onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'userPage',
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 26),
            InkWell(
              onTap: () {},
              child: Image.asset(
                'lib/assets/icons/User_fill_add.png',
                height: 25.r,
                width: 25.r,
              ),
            )
          ],
        ),
        ending: Row(
          children: [
            InkWell(
              onTap: () {},
              child: Image.asset(
                'lib/assets/icons/Out.png',
                height: 25.r,
                width: 25.r,
              ),
            ),
            SizedBox(width: 10.w),
            InkWell(
              onTap: () {
                Get.toNamed('/setting');
              },
              child: Image.asset(
                'lib/assets/icons/Setting_fill.png',
                height: 25.r,
                width: 25.r,
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 头像
            ClipOval(
              child: Container(
                color: MyColor.thirdColor,
                child: Image.asset(
                  'lib/assets/images/male.png',
                  height: 84.r,
                  width: 84.r,
                ),
              ),
            ),

            // 昵称
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Text('Gutabled',
                  style: TextStyle(
                      fontSize: MyFontSize.font19,
                      color: MyColor.mainColor,
                      fontWeight: FontWeight.w600)),
            ),

            // 粉丝关注
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Row(
                    children: [
                      Image.asset(
                        'lib/assets/icons/User_add_alt_fill.png',
                        height: 25.r,
                        width: 25.r,
                      ),
                      SizedBox(width: 5.w),
                      Text('99', style: TextStyle(fontSize: MyFontSize.font12))
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                InkWell(
                  child: Row(
                    children: [
                      Image.asset(
                        'lib/assets/icons/User_add_alt_fill-1.png',
                        height: 25.r,
                        width: 25.r,
                      ),
                      SizedBox(width: 5.w),
                      Text('99', style: TextStyle(fontSize: MyFontSize.font12))
                    ],
                  ),
                )
              ],
            ),
            // 历史记录 我的消息
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // slideButton('兑换商店', () {}),
                slideButton('历史记录', () => Get.toNamed('history')),
                slideButton('我的消息', () => Get.toNamed('message'))
              ],
            ),

            // tab切换栏
            Expanded(
                child: Obx(() => TwoLayerTab(
                      exteriorTabs: const [
                        {'title': '目标', 'nums': '08'},
                        {'title': '收藏', 'nums': '99+'},
                        {'title': '发布', 'nums': '12'}
                      ],
                      interiorTabs: const [
                        {'title': '对外可见'},
                        {'title': '自己可见'}
                      ],
                      // controller中的变量在数组中传递时 需要通过toList才可让Getx检测到
                      exteriorViews: [c.collect.toList(), c.article.toList()],
                      interiorViews: [c.target.toList()],
                    ))),
            // test
            // FloatingActionButton(
            //     onPressed: () {
            //       c.target.removeAt(1);
            //     },
            //     child: const Text('删除'))
          ],
        ),
      ),
    );
  }
}
