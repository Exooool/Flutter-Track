import 'dart:convert';

import 'package:flutter_track/assets/test.dart';
import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  List target = (projectData['project'] as List<dynamic>).obs;
  List collect = ((data['data'] as Map)['news'] as List<dynamic>).obs;
  List article = ((data['data'] as Map)['news'] as List<dynamic>).obs;

  var user = User().obs;

  @override
  void onInit() {
    super.onInit();
    DioUtil().get('/users/get', success: (resuslt) {
      user.value = User.fromMap(resuslt['data'][0]);
    }, error: (error) {
      print('接口请求错误' + error);
    });
  }
}
