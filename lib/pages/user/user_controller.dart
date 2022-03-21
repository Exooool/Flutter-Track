import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_track/assets/test.dart';
import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  List target = [].obs;
  List collect = [].obs;
  List article = [].obs;

  var user = User().obs;

  @override
  void onInit() {
    super.onInit();
    DioUtil().get('/users/get', success: (resuslt) {
      print(resuslt);
      user.value = User.fromMap(resuslt['data'][0]);

      // 获取用户的资讯
      DioUtil().get('/news/getUserNews', success: (success) {
        print(success);
      }, error: (error) {
        print('接口请求错误$error');
      });

      // 获取用户的计划
      DioUtil().get('/project/get', success: (success) {
        print(success);
      }, error: (error) {
        print('接口请求错误$error');
      });

      // 获取用户的收藏
      DioUtil().post('/news/getCollectNew',
          data: {"news_id": resuslt['data'][0]['collection']},
          success: (success) {
        print(success);
      }, error: (error) {
        print('接口请求错误$error');
      });
    }, error: (error) {
      print('接口请求错误$error');
    });
  }
}
