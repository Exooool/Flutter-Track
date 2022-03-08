import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';

// 样式导入
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/components/two_layer_tab.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);
  final UserController c = Get.put(UserController());

  // 关注、粉丝按钮
  Widget smallButton(String title, int nums, Function() onPressed) {
    return CustomButton(
        margin: const EdgeInsets.only(left: 12),
        shadow: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    height: 1,
                    color: MyColor.fontWhite,
                    fontSize: MyFontSize.font12)),
            Container(
              margin: const EdgeInsets.only(left: 4, right: 4),
              decoration: const BoxDecoration(
                  color: MyColor.fontWhiteO5,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: 1,
              height: 14,
            ),
            Text('$nums',
                style: TextStyle(
                    height: 1,
                    color: MyColor.fontWhite,
                    fontSize: MyFontSize.font12))
          ],
        ),
        height: 24,
        width: 59,
        onPressed: onPressed);
  }

  // 侧边按钮
  Widget slideButton(String title, Function() onPressed) {
    return CustomButton(
        title: title,
        shadow: false,
        height: 24,
        width: 80,
        margin: const EdgeInsets.only(bottom: 6),
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
              child: Text(
                '寻找好友',
                style: TextStyle(
                    fontSize: MyFontSize.font14, color: MyColor.fontWhiteO8),
              ),
            )
          ],
        ),
        ending: Row(
          children: [
            InkWell(
              onTap: () {},
              child: Text('分享',
                  style: TextStyle(
                      fontSize: MyFontSize.font14, color: MyColor.fontWhiteO8)),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: () {},
              child: Text('设置',
                  style: TextStyle(
                      fontSize: MyFontSize.font14, color: MyColor.fontWhiteO8)),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // 头像与名字一列成为一行
                Row(
                  children: <Widget>[
                    // 头像
                    ClipOval(
                      child: Container(
                        color: MyColor.thirdColor,
                        child: Image.asset(
                          'lib/assets/images/male.png',
                          height: 84,
                          width: 84,
                        ),
                      ),
                    ),
                    // 用户名以及粉丝关注
                    SizedBox(
                      height: 84,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(left: 12),
                              child: const Text('Gutabled',
                                  style: TextStyle(
                                      color: MyColor.mainColor,
                                      fontWeight: FontWeight.w600))),
                          Row(
                            children: <Widget>[
                              smallButton('关注', 30, () {}),
                              smallButton('粉丝', 30, () {}),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                // 兑换商店等为一列靠近右边
                Column(
                  children: <Widget>[
                    slideButton('兑换商店', () {}),
                    slideButton('历史记录', () {}),
                    slideButton('我的消息', () {})
                  ],
                )
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
                        {'title': '全部'},
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
