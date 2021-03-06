import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_track/pages/components/custom_appbar.dart';

// 样式导入
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';

import 'package:flutter_track/pages/components/two_layer_tab.dart';
import 'package:flutter_track/pages/user/alter_user_info.dart';
import 'package:flutter_track/pages/user/focus_list.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);
  final UserController c = Get.put(UserController());
  final EasyRefreshController _controller = EasyRefreshController();

  // 侧边按钮
  Widget slideButton(String title, Function() onTap) {
    return PublicCard(
        radius: 90.r,
        notWhite: true,
        padding:
            EdgeInsets.only(top: 5.h, bottom: 5.h, left: 12.w, right: 12.w),
        margin: EdgeInsets.only(bottom: 12.h, left: 6.w, right: 6.w),
        onTap: onTap,
        widget: Center(
          child: Text(
            title,
            style: TextStyle(
                fontFamily: MyFontFamily.pingfangSemibold,
                fontSize: MyFontSize.font14,
                color: MyColor.fontWhite),
          ),
        ));
  }

  Future _onRefresh() async {}

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
                  'lib/assets/icons/User_add.png',
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
                  if (c.user.value.userId == -1) {
                    Get.snackbar('提示', '加载失败');
                  } else {
                    Get.toNamed('/setting');
                  }
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
        body: GetX<UserController>(builder: (controller) {
          return c.user.value.userId == -1
              ? InkWell(
                  onTap: () {
                    c.getUserInfo();
                  },
                  child: const Center(
                    child: Text('加载失败，点击重新刷新'),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // 头像
                      Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: () => Get.to(() => AlterUserInfo(),
                                arguments: c.user.value),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: ClipOval(
                                child: SizedBox(
                                  height: 84.r,
                                  width: 84.r,
                                  child: c.user.value.userImg == ''
                                      ? Image.asset(
                                          'lib/assets/images/defaultUserImg.png')
                                      : Image.network(
                                          c.user.value.userImg,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 昵称
                      Padding(
                        padding: EdgeInsets.all(10.h),
                        child: Text(c.user.value.userName,
                            style: TextStyle(
                                fontSize: MyFontSize.font19,
                                fontFamily: MyFontFamily.pingfangSemibold,
                                color: MyColor.mainColor)),
                      ),

                      // 粉丝关注
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () => Get.to(() => FocusList(),
                                arguments: {'type': 0}),
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/icons/User_focus.png',
                                  height: 25.r,
                                  width: 25.r,
                                ),
                                SizedBox(width: 5.w),
                                Text('${c.user.value.focusLength}',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font12,
                                        fontFamily:
                                            MyFontFamily.sfDisplaySemibold))
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w),
                          InkWell(
                            onTap: () => Get.to(() => FocusList(),
                                arguments: {'type': 1}),
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/icons/User_fans.png',
                                  height: 25.r,
                                  width: 25.r,
                                ),
                                SizedBox(width: 5.w),
                                Text('${c.user.value.befocusLength}',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font12,
                                        fontFamily:
                                            MyFontFamily.sfDisplaySemibold))
                              ],
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // 历史记录 我的消息
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // slideButton('兑换商店', () {}),
                          slideButton('历史记录', () => Get.toNamed('history')),
                          slideButton(
                              '我的消息',
                              () => Get.toNamed('message',
                                  arguments: {'user': c.user.value}))
                        ],
                      ),

                      // tab切换栏
                      Expanded(
                          child: TwoLayerTab(
                        type: 1,
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
                        interiorViews: [c.target.toList(), c.targetS.toList()],
                      )),
                    ],
                  ),
                );
        }));
  }
}
