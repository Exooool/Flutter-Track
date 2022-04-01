import 'dart:convert';

import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class UserModelController extends GetxController {
  RxList target = [].obs;
  RxList collect = [].obs;
  RxList article = [].obs;
  // 要查询的用户id
  final Map arguments = Get.arguments;
  // 查询后返回的用户model
  var user = User().obs;
  RxBool isFocus = false.obs;

  getUserInfo() {
    // 查询是否关注
    DioUtil().post('/users/isFocus',
        data: {'other_user_id': arguments['query_user_id']}, success: (res) {
      print(res);
      if (res.length != 0) {
        isFocus.value = true;
      } else {
        isFocus.value = false;
      }
    }, error: (error) {
      print(error);
    });

    // 获取当前用户所有信息
    DioUtil().post('/users/get', data: arguments, success: (resuslt) {
      // print(resuslt);
      user.value = User.fromMap(resuslt['data'][0]);

      // 获取用户的资讯
      DioUtil().post('/news/getUserNews', data: arguments, success: (res) {
        // print('发布的$res');
        article.value = res['data'];
      }, error: (error) {
        print('接口请求错误$error');
      });

      // 获取用户的计划
      DioUtil().post('/project/get', data: arguments, success: (res) {
        // print(res);
        target.value = res['data'];
      }, error: (error) {
        print('接口请求错误$error');
      });

      // 获取用户的收藏
      List list = jsonDecode(resuslt['data'][0]['collection']);
      if (list.isEmpty) {
        // print('用户收藏为空');
        collect.value = [];
      } else {
        DioUtil().post('/news/getCollectNew', data: {"news_id": list},
            success: (res) {
          // print('收藏的$res');
          collect.value = res['data'];
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
    // print(user.value.userId);
  }
}
