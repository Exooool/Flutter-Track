import 'package:flutter/material.dart';
import 'package:flutter_track/common/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      routingCallback: (routing) async {
        if (routing!.current == '/home') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
          if (token == null) {
            // Get.snackbar('提示', '你还未登录');
            Get.toNamed('/login');
          } else {
            print('这是你的token：$token');
          }
        }
      },
    );
  }
}
