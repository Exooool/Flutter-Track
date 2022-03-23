import 'dart:convert';

import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxList target = [].obs;
  RxList collect = [].obs;
  RxList article = [].obs;

  var user = User().obs;

  getUserInfo() {
    DioUtil().post('/users/get', success: (resuslt) {
      print(resuslt);
      user.value = User.fromMap(resuslt['data'][0]);

      // 获取用户的资讯
      DioUtil().post('/news/getUserNews', success: (res) {
        print('用户发布的资讯$res');
        article.value = res['data'];
      }, error: (error) {
        print('接口请求错误$error');
      });

      // 获取用户的计划
      DioUtil().post('/project/get', success: (res) {
        print(res);
        target.value = res['data'];
      }, error: (error) {
        print('接口请求错误$error');
      });

      // 获取用户的收藏
      List list = jsonDecode(resuslt['data'][0]['collection']);
      if (list.isEmpty) {
        print('用户收藏为空');
        collect.value = [];
      } else {
        DioUtil().post('/news/getCollectNew', data: {"news_id": list},
            success: (res) {
          collect.value = res['data'];
          print(res);
        }, error: (error) {
          print('接口请求错误$error');
        });
      }
    }, error: (error) {
      print('接口请求错误$error');
    });
  }

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }
}
