import 'dart:convert';

class User {
  late int userId;
  late String mobile;
  late String userImg;
  late String sex;
  late String userName;
  late String college;
  late String major;
  late int exp;
  late List studyTime;
  late int totalTime;
  late List fans;
  late List focus;
  late List collection;

  User();

  User.fromMap(Map<String, dynamic> json) {
    userId = json['user_id'];
    mobile = json['mobile'];
    userImg = json['user_img'];
    sex = json['sex'];
    userName = json['user_name'];
    college = json['college'];
    major = json['major'];
    exp = json['exp'];
    studyTime = jsonDecode(json['study_time']);
    totalTime = json['total_time'];
    fans = jsonDecode(json['fans']);
    focus = jsonDecode(json['focus']);
    collection = jsonDecode(json['collection']);
  }
}
