import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_track/assets/test.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../common/screen/screen_adaptation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './union_widget.dart';
import '../components/custom_appbar.dart';

class InformationPage extends StatelessWidget {
  InformationPage({Key? key}) : super(key: key);

  final echartsOption = '''
          option = {
        textStyle: {
          color: '#F0F2F3'
        },
        xAxis: {
          type: 'category',
          axisTick: {
            show: false
          },
          axisLine: {
            show: false
          },
          data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun','Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        },
        yAxis: {
          offset: 12,
          axisTick: {
            inside: true,
            show: true,
            length: 12,
            lineStyle: {
              color: "rgba(240, 242, 243, 0.1)"
            }
          },
          
          minorTick: {
            show: true,
            splitNumber: 3,
            length: 12,
            lineStyle: {
              color: "rgba(240, 242, 243, 0.1)"
            }
          },
          splitLine: false,
          type: 'value',
          position: 'right'
        },
        dataZoom: [
          {
            id: 'dataZoomX',
            type: 'inside',
            start:0,
            end: 30,
            xAxisIndex: [0],
            filterMode: 'filter'
        },
        {
            id: 'dataZoomY',
            type: 'inside',
            yAxisIndex: [0],
            filterMode: 'empty'
        }
        ],
        grid:{
          top: '12px',
          left: '0px',
          right: '36px',
          bottom: '36px',
        },
        backgroundColor: '',
        series: [
          {
            data: [120, 200, 150, 80, 70, 110, 130,180, 200, 150, 20,40, 110, 130],
            type: 'bar',
            showBackground: true,
            backgroundStyle: {
            borderWidth: 0.1,
            borderColor: "rgba(240, 242, 243, 1)",
            borderRadius: [30, 30, 30, 30],
            color: "rgba(255, 255, 255, 0)"
          },
            itemStyle: {
                              
                              normal: {
                                color: '#F0F2F3',
                                    //柱形图圆角，初始化效果
                                    barBorderRadius:[20,20, 0, 0]
                              }
                        }
          }
        ]
      }
            ''';

  final List weekList = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  final barData = [
    {'week': 0, 'data': 2},
    {'week': 1, 'data': 3},
    {'week': 2, 'data': 7},
    {'week': 3, 'data': 2},
    {'week': 4, 'data': 4},
    {'week': 5, 'data': 12},
    {'week': 6, 'data': 6},
  ];

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
              Text('$index.',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(240, 242, 243, 1),
                      fontSize: 19)),
              const SizedBox(width: 22),
              const ClipOval(
                child: Icon(Icons.person),
              ),
              Text(userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(240, 242, 243, 1),
                      fontSize: 12))
            ],
          ),
          Text(
            school,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(240, 242, 243, 1),
                fontSize: 12),
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          // 等级显示及签到按钮
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 42.h,
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
                      '等级 Lv7',
                      style: TextStyle(color: Color.fromRGBO(240, 242, 243, 1)),
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
              CustomButton('签到', height: 42.h, width: 80.w, onPressed: () {})
            ],
          ),

          UnionWidget(
              height: 300,
              children: [
                const Text('平均每天',
                    style: TextStyle(color: Color.fromRGBO(240, 242, 243, 1))),
                const Text('5小时18分钟',
                    style: TextStyle(color: Color.fromRGBO(240, 242, 243, 1))),
                const Text('2022年1月16号至1月22号',
                    style: TextStyle(color: Color.fromRGBO(240, 242, 243, 1))),
                Container(
                  color: Colors.transparent,
                  // echarts使用flutter webview会出现背景颜色是白色的情况
                  // 解决方法修改echarts源码 在它的build方法中的webview构造函数中添加以下代码
                  // backgroundColor: Colors.transparent
                  child: Echarts(
                    option: echartsOption,
                  ),
                  height: 200,
                ),
              ],
              title: '数据呈现',
              small: false,
              subTitle: const ['周', '月', '年']),
          const SizedBox(height: 24),
          UnionWidget(
              height: 600,
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return rankingList(index + 1, 'Gutabled', '北京理工大学珠海学院');
                    })
              ],
              title: '排行榜',
              small: true,
              subTitle: const ['总榜', '校榜', '好友榜']),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
