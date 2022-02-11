import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import './pages/reg_and_log.dart';
import './pages/home_menu.dart';
import 'pages/log/verify.dart';
import 'pages/log/fill_userinfo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 去除debug标签
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/log',
      routes: {
        '/log': (context) => const RegPageAndLogPage(),
        '/home': (context) => HomeMenu(),
        '/verify': (context) => VerifyPage(),
        '/fill_userinfo': (context) => const FillUserInfoPage(),
      },
      // home: HomeMenu(),
    );
  }
}
