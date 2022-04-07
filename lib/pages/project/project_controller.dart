import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  // 匹配成功的队列
  List groupListMatched = [].obs;
  // 正在匹配的队列
  List groupListMatching = [].obs;
  // 60分钟内进行的计划
  List projectList1 = [].obs;
  // 其余计划
  List projectList2 = [].obs;

  getProject() {
    DioUtil().post('/project/get', success: (res) {
      // print('计划列表$res');

      // 清空数据 然后请求替换数据
      projectList1 = [];
      projectList2 = [];

      DateTime now = DateTime.now();
      List list = res['data'];
      for (var i = 0; i < list.length; i++) {
        Map m = jsonDecode(list[i]['stage_list'])[0];
        DateTime time;
        if (m.isNotEmpty) {
          // print(m['frequency']['time']);
          time = DateTime(
              now.year,
              now.month,
              now.day,
              int.parse(m['frequency']['time'].substring(0, 2)),
              int.parse(m['frequency']['time'].substring(3, 5)));
        } else {
          Map temp = jsonDecode(list[i]['frequency']);
          time = DateTime(
              now.year,
              now.month,
              now.day,
              int.parse(temp['time'].substring(0, 2)),
              int.parse(temp['time'].substring(3, 5)));
          // print(temp['time']);
        }

        print(time.difference(now).inHours);
        // 判断创建时间是否小于一个小时，小于放在projectlist1，否则放在projectlist2
        if (time.difference(now).inHours.abs() < 1) {
          projectList1.add(list[i]);
        } else {
          projectList2.add(list[i]);
        }
        update();
      }
    }, error: (error) {
      print(error);
    });
  }

  // 获取互助小组信息
  getGroup() {
    DioUtil().get('/project/group/get', success: (res) {
      print('互助小组信息$res');
      List groupInfo = res['data'];
      Map<int, List> m = {};
      // 对获取的数据进行解析
      // 解析到map中
      for (int i = 0; i < groupInfo.length; i++) {
        if (m[groupInfo[i]['group_id']] == null) {
          List l = [];
          l.add(groupInfo[i]);
          m[groupInfo[i]['group_id']] = l;
        } else {
          m[groupInfo[i]['group_id']]!.add(groupInfo[i]);
        }
      }
      // 在通过map的key的list类型的长度来判断是不是在匹配中
      debugPrint('----------------------');
      // 格式化列表
      groupListMatched = [];
      groupListMatching = [];
      for (int i = 0; i < m.length; i++) {
        if (m[m.keys.toList()[i]]!.length < 3) {
          groupListMatching.add(m[m.keys.toList()[i]]);
        } else {
          groupListMatched.add(m[m.keys.toList()[i]]);
        }
      }

      update();

      debugPrint('匹配成功列表：$groupListMatched');
      debugPrint('匹配中列表：$groupListMatching');
      // print(m);
    }, error: (error) {
      print(error);
    });
  }

  getInfo() {
    getProject();
    getGroup();
  }

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }
}
