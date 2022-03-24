import 'dart:convert';

class Project {
  late String projectImg;
  late int projectId;
  late String? groupId;
  late String projectTitle;
  late String endTime;
  late Map singleTime;
  late Map frequency;
  late String secret;
  late int remainderTime;
  late List stageList;
  late List studyTime;
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
