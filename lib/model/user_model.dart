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
  late Map studyTime;
  late int totalTime;
  late int befocusLength;
  late int focusLength;
  late List collection;
  late String? lastSign;

  User({this.userId = -1});

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
    befocusLength = json['befocus_length'];
    focusLength = json['focus_length'];
    collection = jsonDecode(json['collection']);
    lastSign = json['last_sign'];
  }
}
