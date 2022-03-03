import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_track/assets/test.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:get/get.dart';

import 'information_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import './union_widget.dart';
import '../components/custom_appbar.dart';

// 样式导入
import 'package:flutter_track/common/style/myStyle.dart';

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
      'textStyle': {'color': '#F0F2F3'},
      'tooltip': {'trigger': "axis"},
      'xAxis': {
        'type': 'category',
        'axisTick': {'show': false},
        'axisLine': {'show': false},
        'data': weekList
      },
      'yAxis': {
        'min': 0,
        'offset': 12,
        'axisTick': {
          'inside': true,
          'show': true,
          'length': 12,
          'lineStyle': {'color': "rgba(240, 242, 243, 0.1)"}
        },
        'minorTick': {
          'show': true,
          'splitNumber': 3,
          'length': 12,
          'lineStyle': {'color': "rgba(240, 242, 243, 0.1)"}
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
            'borderColor': "rgba(240, 242, 243, 1)",
            'borderRadius': [30, 30, 0, 0],
            'color': "rgba(255, 255, 255, 0)"
          },
          'itemStyle': {
            'normal': {
              'color': '#F0F2F3',
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('$index.', style: MyFontStyle.rankTitle),
              const SizedBox(width: 22),
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
        title: '数据',
        ending: InkWell(
          onTap: () {},
          child: const Text('分享'),
        ),
      ),
      body: GetX<InformationController>(
        init: InformationController(),
        initState: (_) {},
        builder: (_) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 24, right: 24),
            children: <Widget>[
              // 等级显示及签到按钮
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(107, 101, 244, 1),
                              Color.fromRGBO(51, 84, 244, 1)
                            ])),
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        const Text(
                          '等级 Lv',
                          style: TextStyle(
                              color: Color.fromRGBO(240, 242, 243, 1),
                              fontSize: 16),
                        ),
                        Text(
                          '${informationData['level']}',
                          style: const TextStyle(
                              color: Color.fromRGBO(240, 242, 243, 1),
                              fontSize: 19),
                        ),
                        Expanded(
                            child: LinearPercentIndicator(
                          percent: 0.5,
                          barRadius: const Radius.circular(48),
                          progressColor: const Color.fromRGBO(255, 191, 128, 1),
                        ))
                      ],
                    ),
                  )),
                  CustomButton(
                      title: '签到', height: 42, width: 80, onPressed: () {})
                ],
              ),

              UnionWidget(
                  height: 300,
                  index: c.dataBarIndex.value,
                  children: [
                    DefaultTextStyle(
                        style: const TextStyle(
                            color: Color.fromRGBO(240, 242, 243, 1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('平均每天', style: TextStyle(fontSize: 12)),
                            Row(
                              children: const [
                                Text('5', style: TextStyle(fontSize: 28)),
                                Text('小时', style: TextStyle(fontSize: 14)),
                                Text('18', style: TextStyle(fontSize: 28)),
                                Text('分钟', style: TextStyle(fontSize: 14))
                              ],
                            ),
                            const Text('2022年1月16号至1月22号',
                                style: TextStyle(fontSize: 12))
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
                      height: 200,
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
              const SizedBox(height: 24),
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
