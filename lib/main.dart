import 'package:flutter/material.dart';
import 'package:flutter_track/common/routes/app_pages.dart';
import 'package:get/get.dart';
import 'config/app_theme.dart';

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
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // home: HomeMenu(),
    );
  }
}
