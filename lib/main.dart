import 'package:flutter/material.dart';
import 'package:flutter_track/common/routes/app_pages.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  late bool firstUse = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 去除debug标签
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(233, 238, 255, 1),
          splashColor: Colors.transparent, // 取消水波纹特效
          highlightColor: Colors.transparent, // 取消水波纹特效
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent),
          appBarTheme: AppBarTheme(),
          primaryColor: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                  splashFactory: NoSplash.splashFactory))),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
