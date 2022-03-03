import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData theme = ThemeData(
    // scaffoldBackgroundColor: Colors.white, //Scaffold的默认背景颜色
    scaffoldBackgroundColor: const Color.fromRGBO(240, 240, 243, 1),
    splashColor: Colors.transparent, // 取消水波纹特效
    highlightColor: Colors.transparent, // 取消水波纹特效
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.transparent),
    appBarTheme: AppBarTheme(),
    primaryColor: Colors.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0),
            splashFactory: NoSplash.splashFactory)));
