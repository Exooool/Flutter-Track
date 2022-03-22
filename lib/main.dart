import 'package:flutter/material.dart';
import 'package:flutter_track/common/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  late bool firstUse = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 判断是不是第一次登录

    return GetMaterialApp(
      // 去除debug标签
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // home: HomeMenu(),
      routingCallback: (routing) async {
        // if (routing!.current == '/home') {
        //   print(routing)
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   var token = prefs.getString('token');
        //   if (token == null) {
        //     // Get.snackbar('提示', '你还未登录');
        //     Get.toNamed('/login');
        //   } else {
        //     print('这是你的token：$token');
        //   }
        // }
      },
    );
  }
}
