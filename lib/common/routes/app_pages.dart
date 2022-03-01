import 'package:get/get.dart';

import 'package:flutter_track/pages/home_menu.dart';
import 'package:flutter_track/pages/log/fill_userinfo.dart';
import 'package:flutter_track/pages/log/verify.dart';
import 'package:flutter_track/pages/project/add_project.dart';
import 'package:flutter_track/pages/project/invite_group.dart';
import 'package:flutter_track/pages/project/match_group.dart';
import 'package:flutter_track/pages/log/log.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(name: '/home', page: () => HomeMenu()),
    GetPage(name: '/log', page: () => const RegPageAndLogPage()),
    GetPage(name: '/verify', page: () => VerifyPage()),
    GetPage(name: '/fill_userinfo', page: () => const FillUserInfoPage()),
    GetPage(name: '/add_project', page: () => AddProject()),
    GetPage(name: '/match_group', page: () => const MatchGroup()),
    GetPage(name: '/invite_group', page: () => const InviteGroup()),
  ];
}