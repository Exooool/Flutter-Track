import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/assets/test.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';

import 'information_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../components/union_widget.dart';
import '../components/custom_appbar.dart';

// 样式导入
import 'package:flutter_track/common/style/my_style.dart';

class InformationPage extends StatelessWidget {
  final InformationController c = Get.put(InformationController());

  InformationPage({Key? key}) : super(key: key);

  String getData() {
    List weekList;
    List timeList;
    weekList = (informationData['data'] as List<dynamic>).map((item) {
      return item['week'];
    }).toList();

    timeList = (informationData['data'] as List<dynamic>).map((item) {
      return item['time'];
    }).toList();

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
          'endValue': 30,
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

  final List weekList = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  // 排行榜数据
  final rankingListData = [
    {
      'userName',
    }
  ];

  // 排行榜
  Widget rankingList(int index, String userName, String school) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('$index.', style: MyFontStyle.rankTitle),
              SizedBox(width: 22.w),
              const ClipOval(
                child: Icon(Icons.person),
              ),
              Text(userName, style: MyFontStyle.rankUser)
            ],
          ),
          Text(
            school,
            style: MyFontStyle.rankSchool,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'infoPage',
        ending: InkWell(
          onTap: () {},
          child: Image.asset(
            'lib/assets/icons/Out.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: GetX<InformationController>(
        init: InformationController(),
        initState: (_) {},
        builder: (_) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 24.w, right: 24.w),
            children: <Widget>[
              // 等级显示及签到按钮
              Row(
                children: [
                  Expanded(
                      child: PublicCard(
                    radius: 10.r,
                    height: 42.h,
                    widget: Row(
                      children: [
                        const SizedBox(width: 24),
                        Text(
                          '等级 Lv',
                          style: TextStyle(
                              color: MyColor.fontBlack,
                              fontSize: MyFontSize.font16),
                        ),
                        Text(
                          '${informationData['level']}',
                          style: TextStyle(
                              color: MyColor.fontBlack,
                              fontSize: MyFontSize.font19),
                        ),
                        Expanded(
                            child: LinearPercentIndicator(
                                percent: 0.5,
                                barRadius: const Radius.circular(48),
                                // backgroundColor: Colors.transparent,
                                linearGradient:
                                    MyWidgetStyle.mainLinearGradient))
                      ],
                    ),
                  )),
                  CustomButton(
                      margin: EdgeInsets.only(left: 12.w),
                      title: '签到',
                      height: 42.h,
                      width: 80.w,
                      onPressed: () {})
                ],
              ),

              SizedBox(height: 24.h),

              UnionWidget(children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'lib/assets/images/logo.png',
                        height: 154.r,
                        width: 154.r,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('5',
                              style: TextStyle(
                                  fontSize: MyFontSize.font28,
                                  fontWeight: FontWeight.w600)),
                          Text('小时',
                              style: TextStyle(
                                  fontSize: MyFontSize.font14,
                                  fontWeight: FontWeight.w600)),
                          Text('18',
                              style: TextStyle(
                                  fontSize: MyFontSize.font28,
                                  fontWeight: FontWeight.w600)),
                          Text('分钟',
                              style: TextStyle(
                                  fontSize: MyFontSize.font14,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      Text('已超越80%的用户',
                          style: TextStyle(fontSize: MyFontSize.font12))
                    ],
                  ),
                )
              ], title: '今日累计', height: 276.h),

              SizedBox(height: 24.h),
              UnionWidget(
                  height: 300.h,
                  index: c.dataBarIndex.value,
                  children: [
                    DefaultTextStyle(
                        style: const TextStyle(color: MyColor.fontBlack),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('平均每天',
                                style: TextStyle(fontSize: MyFontSize.font12)),
                            Row(
                              children: [
                                Text('5',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font28,
                                        fontWeight: FontWeight.w600)),
                                Text('小时',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font14,
                                        fontWeight: FontWeight.w600)),
                                Text('18',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font28,
                                        fontWeight: FontWeight.w600)),
                                Text('分钟',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font14,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                            Text('2022年1月16号至1月22号',
                                style: TextStyle(fontSize: MyFontSize.font12))
                          ],
                        )),
                    Container(
                      color: Colors.transparent,
                      // echarts使用flutter webview会出现背景颜色是白色的情况
                      // 解决方法修改echarts源码 在它的build方法中的webview构造函数中添加以下代码
                      // backgroundColor: Colors.transparent
                      child: Echarts(
                        option: getData(),
                      ),
                      height: 200.h,
                    ),
                  ],
                  title: '数据呈现',
                  subTitle: const ['周', '月', '年'],
                  onTapOne: () {
                    c.dataBarIndex.value = 0;
                  },
                  onTapTwo: () {
                    c.dataBarIndex.value = 1;
                  },
                  onTapThree: () {
                    c.dataBarIndex.value = 2;
                  }),
              SizedBox(height: 24.h),
              UnionWidget(
                  height: 600,
                  index: c.rankBarIndex.value,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return rankingList(
                              index + 1, 'Gutabled', '北京理工大学珠海学院');
                        })
                  ],
                  title: '排行榜',
                  subTitle: const ['总榜', '校榜', '好友榜'],
                  onTapOne: () {
                    c.rankBarIndex.value = 0;
                  },
                  onTapTwo: () {
                    c.rankBarIndex.value = 1;
                  },
                  onTapThree: () {
                    c.rankBarIndex.value = 2;
                  }),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
