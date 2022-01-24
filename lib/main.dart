import 'package:flutter/material.dart';
import './pages/reg_and_log.dart';
import './pages/home_menu.dart';

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

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, //Scaffold的默认背景颜色
        splashColor: Colors.transparent, // 取消水波纹特效
        highlightColor: Colors.transparent, // 取消水波纹特效
        backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.transparent),
      ),
      home: HomeMenu(),
    );
  }
}
