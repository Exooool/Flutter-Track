import 'package:flutter_track/pages/discover/article.dart';
import 'package:flutter_track/pages/discover/news_edit.dart';
import 'package:flutter_track/pages/log/userinfo_form/userinfo_form.dart';
import 'package:flutter_track/pages/setting/setting.dart';
import 'package:flutter_track/pages/user/chart.dart';
import 'package:flutter_track/pages/user/history.dart';
import 'package:flutter_track/pages/user/message.dart';
import 'package:get/get.dart';

import 'package:flutter_track/pages/home_menu.dart';

import 'package:flutter_track/pages/log/verify.dart';
import 'package:flutter_track/pages/project/add_project.dart';
import 'package:flutter_track/pages/project/invite_group.dart';
import 'package:flutter_track/pages/project/match_group.dart';
import 'package:flutter_track/pages/log/log.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(name: '/home', page: () => const HomeMenu()),
    GetPage(name: '/log', page: () => const RegPageAndLogPage()),
    GetPage(name: '/verify', page: () => const VerifyPage()),
    GetPage(name: '/sex_info', page: () => const SexSelector()),
    GetPage(name: '/add_project', page: () => AddProject()),
    GetPage(name: '/match_group', page: () => MatchGroup()),
    GetPage(name: '/invite_group', page: () => InviteGroup()),
    GetPage(name: '/setting', page: () => const SettingPage()),
    GetPage(name: '/newsEdit', page: () => NewsEdit()),
    GetPage(name: '/article', page: () => ArticlePage()),
    GetPage(name: '/message', page: () => MessagePage()),
    GetPage(name: '/history', page: () => HistoryPage()),
    GetPage(name: '/chart', page: () => ChartPage()),
  ];
}
