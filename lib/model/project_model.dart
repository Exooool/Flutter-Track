import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class Project {
  late IconInfo iconInfo;
  late String projectId;
  late String userId;
  late String projectTtile;
  late String endTime;
  late List<Stage> stageList;
  late bool isJoin;
  Project.fromMap(Map<String, dynamic> json) {
    iconInfo = IconInfo.fromMap(json['iconInfo']);
    projectId = json['projectId'];
    userId = json['userId'];
    projectTtile = json['projectTtile'];
    endTime = json['endTime'];
    isJoin = json['isJoin'];
    stageList = (json['stageList'] as List<dynamic>).map((item) {
      return Stage.fromMap(item);
    }).toList();
  }
}

class IconInfo {
  late String icon;
  late String color;
  IconInfo.fromMap(Map<String, dynamic> json) {
    icon = json['icon'];
    color = json['color'];
  }
}

class Stage {
  late String content;
  late String endTime;
  // 完成频率
  late String frequency;
  // 提醒时间
  late String reminderTime;
  Stage.fromMap(Map<String, dynamic> json) {
    content = json['content'];
    endTime = json['endTime'];
    frequency = json['frequency'];
    reminderTime = json['reminderTime'];
  }
}
