import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_track/pages/discover/discover.dart';
import 'package:flutter_track/pages/user/user.dart';
import 'package:flutter_track/pages/project/project.dart';
import 'package:flutter_track/pages/information/information.dart';
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

  Widget _menuItem(
      String unselected, String selected, int index, String title) {
    return InkWell(
        onTap: () {
          setState(() {
            _isNavShow = true;
            _index = index;
            Vibrate.feedback(FeedbackType.light);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 17.5, right: 17.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   icon,
              //   color: _index == index ? Colors.blue : Colors.white,
              //   size: 40,
              // ),
              Image.asset(
                _index == index ? selected : unselected,
                height: 40,
                width: 40,
              ),
              Text(
                title,
                style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1), fontSize: 10),
              )
            ],
          ),
        ));
  }

  // 导航栏透明度
  var _isNavShow = true;
  String i = '1';
  // 导航栏
  Widget navigatorBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 64,
          width: 320,
          decoration: BoxDecoration(
              color: _isNavShow
                  ? const Color.fromRGBO(43, 43, 43, 0.95)
                  : const Color.fromRGBO(43, 43, 43, 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(43.3125))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _menuItem('lib/assets/icons/nav_1.png',
                    'lib/assets/icons/nav_fill_1.png', 0, '计划'),
                _menuItem('lib/assets/icons/nav_2.png',
                    'lib/assets/icons/nav_fill_2.png', 1, '发现'),
                _menuItem('lib/assets/icons/nav_3.png',
                    'lib/assets/icons/nav_fill_3.png', 2, '数据'),
                _menuItem('lib/assets/icons/nav_4.png',
                    'lib/assets/icons/nav_fill_4.png', 3, '个人'),
              ]),
        ),
      ],
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
  Widget build(BuildContext context) {
    loginVerify();

    double _phoneWidth = MediaQuery.of(context).size.width;
    double distance = (_phoneWidth - 320) / 2;

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
            Positioned(
                left: distance,
                right: distance,
                bottom: 34,
                child: navigatorBar())
          ]),
        ));
  }
}
