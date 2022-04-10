import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_track/common/style/my_style.dart';

import 'package:flutter_track/pages/discover/discover.dart';
import 'package:flutter_track/pages/information/information_controller.dart';
import 'package:flutter_track/pages/project/project_controller.dart';
import 'package:flutter_track/pages/user/user.dart';
import 'package:flutter_track/pages/project/project.dart';
import 'package:flutter_track/pages/information/information.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './discover/news_page.dart';

// 屏幕适配
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  int _index = 1;
  final List _pageList = [
    ProjectPage(),
    DiscoverPage(),
    InformationPage(),
    UserPage()
  ];

  // 导航栏按钮样式

  Widget _menuItem(String unselected, String selected, int index, String title,
      String dynamic) {
    bool showDynamic = false;
    return InkWell(
        onTap: () {
          setState(() {
            _isNavShow = true;
            _index = index;
            Vibrate.feedback(FeedbackType.light);
            showDynamic = true;
            setState(() {});
            print(showDynamic);
          });
          if (index == 3) {
            UserController u = Get.find();
            u.getUserInfo();
          } else if (index == 0) {
            ProjectController p = Get.put(ProjectController());

            if (p.initialized) {
              p.getInfo();
            }
          } else if (index == 2) {
            InformationController i = Get.find();
            i.getInformation();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 17.5, right: 17.5),
          child: Opacity(
            opacity: _index == index ? 1 : 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showDynamic
                    ? Image(image: AssetImage(dynamic), height: 40, width: 40)
                    : Image.asset(
                        _index == index ? selected : unselected,
                        height: 40,
                        width: 40,
                      ),
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: MyFontFamily.pingfangSemibold,
                      color: MyColor.fontWhite,
                      fontSize: MyFontSize.font12),
                )
              ],
            ),
          ),
        ));
  }

  // 导航栏透明度
  var _isNavShow = true;
  String i = '1';
  // 导航栏
  Widget navigatorBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: 11.5.w, right: 11.5.w, top: 5.h, bottom: 5.h),
            decoration: BoxDecoration(
                color: _isNavShow
                    ? const Color.fromRGBO(43, 43, 43, 0.95)
                    : const Color.fromRGBO(43, 43, 43, 0.2),
                borderRadius: const BorderRadius.all(Radius.circular(43.3125))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _menuItem(
                      'lib/assets/icons/nav_1.png',
                      'lib/assets/icons/nav_fill_1.png',
                      0,
                      '计划',
                      'lib/assets/gifs/1 计划.gif'),
                  _menuItem(
                      'lib/assets/icons/nav_2.png',
                      'lib/assets/icons/nav_fill_2.png',
                      1,
                      '资讯',
                      'lib/assets/gifs/2 资讯.gif'),
                  _menuItem(
                      'lib/assets/icons/nav_3.png',
                      'lib/assets/icons/nav_fill_3.png',
                      2,
                      '数据',
                      'lib/assets/gifs/3 数据.gif'),
                  _menuItem(
                      'lib/assets/icons/nav_4.png',
                      'lib/assets/icons/nav_fill_4.png',
                      3,
                      '个人',
                      'lib/assets/gifs/4 个人.gif'),
                ]),
          ),
        ],
      ),
    );
  }

  loginVerify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token == null || token == '') {
      debugPrint('未登录：$token');
      Get.offAllNamed('/log');
      // Get.snackbar('提示', '未登录');
    } else {
      debugPrint('该用户已登录：$token');
    }
  }

  @override
  void initState() {
    super.initState();
    loginVerify();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: NotificationListener<NavNotification>(
          onNotification: (n) {
            // print(n.isNavShow);
            setState(() {
              _isNavShow = n.isNavShow;
            });
            return true;
          },
          child: Stack(children: [
            _pageList[_index],
            Positioned(bottom: 34.h, child: navigatorBar())
          ]),
        ));
  }
}
