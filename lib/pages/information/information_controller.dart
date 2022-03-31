import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class InformationController extends GetxController {
  RxInt dataBarIndex = 0.obs;
  RxInt rankBarIndex = 0.obs;
  var user = User().obs;
  RxInt dataTime = 7.obs;
  RxBool isSign = false.obs;
  RxInt nowDatStudyTime = 0.obs;
  RxInt averDayStudyTime = 0.obs;
  final List weekListCN = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  final DateTime now = DateTime.now();
  RxList rankList = [].obs;

  final List clockList = [
    '1.png',
    '1-30.png',
    '2.png',
    '2-30.png',
    '3.png',
    '3-30.png',
    '4.png',
    '4-30.png',
    '5.png',
    '5-30.png',
    '6.png',
    '6-30.png',
    '7.png',
    '7-30.png',
    '8.png',
    '8-30.png',
    '9.png',
    '9-30.png',
    '10.png',
    '10-30.png',
    '11.png',
    '11-30.png',
    '12.png',
    '12-30.png',
  ];

  clock() {
    if (nowDatStudyTime.value != 0) {
      int h = (nowDatStudyTime.value ~/ 60) * 2;
      int m = nowDatStudyTime.value % 60;
      if (m < 30 && h != 0) {
        h--;
      }
      print(h);
      return 'lib/assets/clock/' + clockList[h];
    } else {
      return 'lib/assets/clock/1.png';
    }
  }

  getInformation() {
    // 获取用户数据
    DioUtil().post('/users/get', success: (res) {
      print(res);
      user.value = User.fromMap(res['data'][0]);
      print('时间：${user.value.lastSign}');

      // 计算签到
      if (user.value.lastSign != null) {
        DateTime dateTime = DateTime.parse(user.value.lastSign!);
        if (dateTime.difference(now).inDays.abs() < 1) {
          isSign.value = true;
        }
      }

      // 查找当日学习时间
      Map studyList = user.value.studyTime;

      studyList.forEach((key, value) {
        DateTime dateTime = DateTime.parse(key);
        if (dateTime.difference(now).inDays.abs() < 1) {
          nowDatStudyTime.value = value;
        }
      });
      for (var i = 0; i < studyList.length; i++) {}

      if (studyList.isNotEmpty) {
        averDayStudyTime.value = user.value.totalTime ~/ studyList.length;
      }
    }, error: (error) {
      print(error);
    });

    // 获取排行榜数据
    DioUtil().post('/users/rank', success: (res) {
      print(res);
      rankList.value = res['data'];
    }, error: (error) {
      print(error);
    });
  }

  sign() {
    DioUtil().post('/users/sign', data: {'datetime': now.toString()},
        success: (res) {
      print(res);
      Get.snackbar('提示', '签到成功');
    }, error: (error) {
      print(error);
      Get.snackbar('提示', '签到失败，网络异常');
    });
  }

  String getData() {
    List weekList = [];
    List timeList = [];
    Map studyList = user.value.studyTime;
    if (studyList.isEmpty) {
    } else {
      studyList.forEach((key, value) {
        DateTime dt = DateTime.parse(key);
        weekList.add(weekListCN[dt.weekday - 1]);
        timeList.add((value / 60).toStringAsFixed(1));
      });
    }

    // print(weekList);
    // print(timeList);

    var list = {
      'textStyle': {'color': 'rgba(0, 0, 0, 1)'},
      'tooltip': {'trigger': "axis"},
      'xAxis': {
        'type': 'category',
        'axisTick': {'show': false},
        'axisLine': {'show': false},
        'data': weekList
      },
      'yAxis': {
        'min': 0,
        'offset': 14.w,
        'axisTick': {
          'inside': true,
          'show': true,
          'length': 12.w,
          'lineStyle': {'color': "rgba(0, 0, 0, 0.1)"}
        },
        'minorTick': {
          'show': true,
          'splitNumber': 3,
          'length': 12.w,
          'lineStyle': {'color': "rgba(0, 0, 0, 0.1)"}
        },
        'splitLine': false,
        'type': 'value',
        'axisLabel': {'formatter': '{value}h'},
        'position': 'right'
      },
      'dataZoom': [
        {
          'id': 'dataZoomX',
          'type': 'inside',
          'startValue': 0,
          'endValue': dataTime.value,
          'throttle': 0,
          'filterMode': 'filter'
        }
      ],
      'grid': {
        'top': '12px',
        'left': '0px',
        'right': '48px',
        'bottom': '36px',
      },
      'backgroundColor': '',
      'series': [
        {
          'data': timeList,
          'type': 'bar',
          'showBackground': true,
          'backgroundStyle': {
            'borderWidth': 0.1,
            'borderColor': "rgba(107, 101, 244, 1)",
            'borderRadius': [30, 30, 0, 0],
            'color': "rgba(255, 255, 255, 0)"
          },
          'itemStyle': {
            'normal': {
              'color': 'rgba(107, 101, 244, 1)',
              //柱形图圆角，初始化效果
              'barBorderRadius': [30, 30, 0, 0]
            }
          }
        }
      ]
    };

    // print(list);
    return const JsonEncoder().convert(list);
  }

  @override
  void onInit() {
    super.onInit();
    getInformation();
  }
}
