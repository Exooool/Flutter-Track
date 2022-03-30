import 'dart:convert';

class Project {
  late String projectImg;
  late int projectId;
  late int? groupId;
  late String projectTitle;
  late String endTime;
  late Map singleTime;
  late Map frequency;
  late String secret;
  late int remainderTime;
  late List stageList;
  late Map studyTime;
  late DateTime createTime;
  Project.fromMap(Map<String, dynamic> json) {
    projectImg = json['project_img'];
    projectId = json['project_id'];
    projectTitle = json['project_title'];
    endTime = json['end_time'];
    groupId = json['group_id'];
    stageList = jsonDecode(json['stage_list']);
    frequency = jsonDecode(json['frequency']);
    singleTime = jsonDecode(json['single_time']);
    remainderTime = json['remainder_time'];
    secret = json['secret'];
    studyTime = jsonDecode(json['study_time']);
    createTime = DateTime.parse(json['create_time']);
    // stageList = (json['stageList'] as List<dynamic>).map((item) {
    //   return Stage.fromMap(item);
    // }).toList();
  }

  // 获取当前阶段
  nowStage() {
    int totalStage = stageList.length;
    int nowStage = totalStage;
    DateTime now = DateTime.now();
    if (stageList[0]['endTime'] != null) {
      // 这是分了阶段的判断
      for (var i = 0; i < totalStage; i++) {
        DateTime set = DateTime.parse(stageList[i]['endTime']);
        if (set.isAfter(now)) {
          // 如果第i阶段的截止时间比现在的时间大，说明现在处于第i阶段
          nowStage = i + 1;
          break;
        }
      }
    } else {
      // 这是没有分阶段的判断
      DateTime set = DateTime.parse(endTime);
      if (set.isAfter(now)) {
        nowStage = 1;
      }
    }

    return nowStage;
  }

  // 获取当前

  // 转化singleTime
  singleTimeTf(Map map) {
    final singleTimeType = [30, 60, 90, 120, 150];
    if (map['type'] != 5) {
      return singleTimeType[map['type']];
    } else {
      return map['custom'];
    }
  }
}

// class IconInfo {
//   late String icon;
//   late String color;
//   IconInfo.fromMap(Map<String, dynamic> json) {
//     icon = json['icon'];
//     color = json['color'];
//   }
// }

// class Stage {
//   late String content;
//   late String endTime;
//   // 完成频率
//   late String frequency;
//   // 提醒时间
//   late String reminderTime;
//   Stage.fromMap(Map<String, dynamic> json) {
//     content = json['content'];
//     endTime = json['endTime'];
//     frequency = json['frequency'];
//     reminderTime = json['reminderTime'];
//   }
// }
