import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_theme.dart';
import './pages/reg_and_log.dart';
import './pages/home_menu.dart';
import 'pages/log/verify.dart';
import 'pages/log/fill_userinfo.dart';
import './pages/project/add_project.dart';
import './pages/project/match.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 去除debug标签
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/match',
      getPages: [
        GetPage(name: '/log', page: () => const RegPageAndLogPage()),
        GetPage(name: '/home', page: () => HomeMenu()),
        GetPage(name: '/verify', page: () => VerifyPage()),
        GetPage(name: '/fill_userinfo', page: () => const FillUserInfoPage()),
        GetPage(name: '/add_project', page: () => AddProject()),
        GetPage(name: '/match', page: () => const Match())
      ],
      // home: HomeMenu(),
    );
  }
}
