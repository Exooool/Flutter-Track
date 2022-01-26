import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData theme = ThemeData(
  scaffoldBackgroundColor: Colors.white, //Scaffold的默认背景颜色
  splashColor: Colors.transparent, // 取消水波纹特效
  highlightColor: Colors.transparent, // 取消水波纹特效
  backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(backgroundColor: Colors.transparent),
  appBarTheme: AppBarTheme(),
);
