import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  // 排行榜数据
  final rankingListData = [
    {
      'userName',
    }
  ];

  // 排行榜
  Widget rankingList(int index, String img, String userName, String school) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 22.w,
                child: Text('$index.', style: MyFontStyle.rankTitle),
              ),
              SizedBox(width: 22.w),
              ClipOval(
                child: img == ''
                    ? Image.asset('lib/assets/images/defaultUserImg.png',
                        height: 36.r, width: 36.r)
                    : Image.network(img, height: 36.r, width: 36.r),
              ),
              SizedBox(width: 12.w),
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
        builder: (_) {
          return c.user.value.userId == -1
              ? InkWell(
                  onTap: () {
                    c.getInformation();
                  },
                  child: const Center(
                    child: Text('加载失败，点击重新刷新'),
                  ),
                )
              : ListView(
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
                                '${c.user.value.exp ~/ 1000}',
                                style: TextStyle(
                                    color: MyColor.fontBlack,
                                    fontSize: MyFontSize.font19),
                              ),
                              Expanded(
                                  child: LinearPercentIndicator(
                                      percent: (c.user.value.exp % 1000) / 1000,
                                      barRadius: const Radius.circular(48),
                                      // backgroundColor: Colors.transparent,
                                      linearGradient:
                                          MyWidgetStyle.mainLinearGradient))
                            ],
                          ),
                        )),
                        Opacity(
                          opacity: c.isSign.value ? 0.5 : 1,
                          child: CustomButton(
                              margin: EdgeInsets.only(left: 12.w),
                              title: '签到',
                              height: 42.h,
                              width: 80.w,
                              onPressed: () {
                                if (!c.isSign.value) {
                                  c.sign();

                                  c.getInformation();
                                } else {
                                  Get.snackbar('提示', '你已经签到过了');
                                }
                              }),
                        )
                      ],
                    ),

                    SizedBox(height: 24.h),

                    UnionWidget(children: <Widget>[
                      Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10.h),
                            Image.asset(
                              c.clock(),
                              height: 154.r,
                              width: 154.r,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${c.nowDatStudyTime.value ~/ 60}',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font28,
                                        fontWeight: FontWeight.w600)),
                                Text('小时',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font14,
                                        fontWeight: FontWeight.w600)),
                                Text('${c.nowDatStudyTime.value % 60}',
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
                              child: c.averDayStudyTime.value == 0
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('平均每天',
                                            style: TextStyle(
                                                fontSize: MyFontSize.font12)),
                                        Row(
                                          children: [
                                            Text(
                                                '${c.averDayStudyTime.value ~/ 60}',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font28,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text('小时',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                '${c.averDayStudyTime.value % 60}',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font28,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text('分钟',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font14,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                        Text('2022年1月16号至1月22号',
                                            style: TextStyle(
                                                fontSize: MyFontSize.font12))
                                      ],
                                    )),
                          Container(
                            color: Colors.transparent,
                            // echarts使用flutter webview会出现背景颜色是白色的情况
                            // 解决方法修改echarts源码 在它的build方法中的webview构造函数中添加以下代码
                            // backgroundColor: Colors.transparent
                            child: c.averDayStudyTime.value == 0
                                ? const Center(
                                    child: Text('你还没有学习过，快去创建一个计划吧'),
                                  )
                                : Echarts(
                                    option: c.getData(),
                                  ),
                            height: 200.h,
                          ),
                        ],
                        title: '数据呈现',
                        subTitle: const ['周', '月', '年'],
                        onTapOne: () {
                          c.dataBarIndex.value = 0;
                          c.dataTime.value = 7;
                        },
                        onTapTwo: () {
                          c.dataBarIndex.value = 1;
                          c.dataTime.value = 30;
                        },
                        onTapThree: () {
                          c.dataBarIndex.value = 2;
                          c.dataTime.value = 365;
                        }),
                    SizedBox(height: 24.h),
                    UnionWidget(
                        height: 600.h,
                        index: c.rankBarIndex.value,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: c.rankList.length,
                              itemBuilder: (context, index) {
                                return rankingList(
                                    index + 1,
                                    c.rankList[index]['user_img'],
                                    c.rankList[index]['user_name'],
                                    c.rankList[index]['college']);
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
