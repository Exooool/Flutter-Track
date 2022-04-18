import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/pages/components/custom_checkbox.dart';
import 'package:flutter_track/pages/components/custom_dialog.dart';

import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/user/user_model.dart';
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

  // 排行榜
  Widget rankingList(
      int index, int userId, String img, String userName, String school) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 30.w,
                child: Text('$index.', style: MyFontStyle.rankTitle),
              ),
              SizedBox(width: 22.w),
              InkWell(
                  onTap: () {
                    print(userId);
                    if (userId != c.user.value.userId) {
                      Get.to(() => UserModelPage(),
                          arguments: {'query_user_id': userId});
                    }
                  },
                  child: ClipOval(
                    child: img == ''
                        ? Image.asset('lib/assets/images/defaultUserImg.png',
                            height: 36.r, width: 36.r, fit: BoxFit.cover)
                        : Image.network(img,
                            height: 36.r, width: 36.r, fit: BoxFit.cover),
                  )),
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

  Widget shareCardItem(String title, bool value, Function onTap) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
          CustomCheckBox(
              value: value,
              onChanged: (value) {
                onTap(value);
              })
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
          onTap: () {
            Get.dialog(
              CustomDialog(
                height: 330,
                width: 318.w,
                title: '请选择您要分享的板块',
                onCancel: () {
                  Get.back();
                },
                contentColumn: <Widget>[
                  shareCardItem('日累计时长', true, (value) {}),
                  shareCardItem('周累计时长', true, (value) {}),
                  shareCardItem('月累计时长', true, (value) {}),
                  shareCardItem('年累计时长', true, (value) {}),
                ],
                onConfirm: () {
                  Get.snackbar('提示', '当前分享功能还未完善');
                },
                confirmText: '生成卡片',
              ),
              barrierColor: Colors.transparent,
            );
          },
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
                  padding:
                      EdgeInsets.only(left: 24.w, right: 24.w, bottom: 50.h),
                  children: <Widget>[
                    // 等级显示及签到按钮
                    Row(
                      children: [
                        Expanded(
                            child: PublicCard(
                          radius: 10.r,
                          padding: EdgeInsets.only(top: 11.h, bottom: 11.h),
                          widget: Row(
                            children: [
                              const SizedBox(width: 24),
                              Text(
                                '等级 ',
                                style: TextStyle(
                                    color: MyColor.fontBlack,
                                    fontFamily: MyFontFamily.pingfangSemibold,
                                    fontSize: MyFontSize.font16),
                              ),
                              Text(
                                'Lv',
                                style: TextStyle(
                                    color: MyColor.fontBlack,
                                    fontFamily: MyFontFamily.sfDisplayBold,
                                    fontSize: MyFontSize.font16),
                              ),
                              Text(
                                '${c.user.value.exp ~/ 1000}',
                                style: TextStyle(
                                    color: MyColor.fontBlack,
                                    fontFamily: MyFontFamily.sfDisplayBold,
                                    fontSize: MyFontSize.font20),
                              ),
                              Expanded(
                                  child: Stack(
                                children: [
                                  LinearPercentIndicator(
                                      lineHeight: 6,
                                      percent: (c.user.value.exp % 1000) / 1000,
                                      barRadius: const Radius.circular(48),
                                      backgroundColor: Colors.transparent,
                                      // backgroundColor: Colors.transparent,
                                      linearGradient:
                                          MyWidgetStyle.mainLinearGradient),
                                  Container(
                                    height: 6,
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: MyColor.mainColor, width: 2),
                                      // gradient:
                                      //     MyWidgetStyle.mainLinearGradient,
                                    ),
                                  )
                                ],
                              ))
                            ],
                          ),
                        )),
                        Opacity(
                          opacity: c.isSign.value ? 0.5 : 1,
                          child: PublicCard(
                              radius: 90.r,
                              notWhite: true,
                              margin: EdgeInsets.only(left: 12.w),
                              padding: EdgeInsets.only(
                                  left: 24.w,
                                  right: 24.w,
                                  top: 13.h,
                                  bottom: 13.h),
                              widget: Text(
                                '签到',
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    color: MyColor.fontWhite,
                                    fontFamily: MyFontFamily.pingfangSemibold),
                              ),
                              onTap: () {
                                if (!c.isSign.value) {
                                  c.sign();

                                  c.getInformation();
                                } else {
                                  Get.snackbar('提示', '您已经签到过了');
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
                              height: 154,
                              width: 154,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${c.nowDatStudyTime.value ~/ 60}',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font28,
                                        fontFamily:
                                            MyFontFamily.sfDisplaySemibold,
                                        fontWeight: FontWeight.w600)),
                                Text('小时',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font14,
                                        fontFamily:
                                            MyFontFamily.pingfangSemibold,
                                        fontWeight: FontWeight.w600)),
                                Text('${c.nowDatStudyTime.value % 60}',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font28,
                                        fontFamily:
                                            MyFontFamily.sfDisplaySemibold,
                                        fontWeight: FontWeight.w600)),
                                Text('分钟',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font14,
                                        fontFamily:
                                            MyFontFamily.pingfangSemibold,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                            Text('已超越0%的用户',
                                style: TextStyle(
                                  fontSize: MyFontSize.font12,
                                  fontFamily: MyFontFamily.pingfangRegular,
                                ))
                          ],
                        ),
                      )
                    ], title: '今日累计', height: 276),

                    SizedBox(height: 24.h),
                    UnionWidget(
                        height: 360.h,
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
                                                fontFamily:
                                                    MyFontFamily.pingfangMedium,
                                                fontSize: MyFontSize.font12)),
                                        Row(
                                          children: [
                                            Text(
                                                '${c.averDayStudyTime.value ~/ 60}',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font28,
                                                    fontFamily: MyFontFamily
                                                        .sfDisplaySemibold)),
                                            Text('小时',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font14,
                                                    fontFamily: MyFontFamily
                                                        .pingfangSemibold)),
                                            Text(
                                                '${c.averDayStudyTime.value % 60}',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font28,
                                                    fontFamily: MyFontFamily
                                                        .sfDisplaySemibold)),
                                            Text('分钟',
                                                style: TextStyle(
                                                    fontSize: MyFontSize.font14,
                                                    fontFamily: MyFontFamily
                                                        .pingfangSemibold))
                                          ],
                                        ),
                                        Text('2022年1月16号至1月22号',
                                            style: TextStyle(
                                                fontSize: MyFontSize.font12,
                                                fontFamily: MyFontFamily
                                                    .pingfangMedium))
                                      ],
                                    )),
                          Container(
                            color: Colors.transparent,
                            // echarts使用flutter webview会出现背景颜色是白色的情况
                            // 解决方法修改echarts源码 在它的build方法中的webview构造函数中添加以下代码
                            // backgroundColor: Colors.transparent
                            child: c.averDayStudyTime.value == 0
                                ? Center(
                                    child: Text(
                                      '您还没有学习过，快去创建一个计划吧',
                                      style: TextStyle(
                                          fontFamily:
                                              MyFontFamily.pingfangMedium,
                                          fontSize: MyFontSize.font16),
                                    ),
                                  )
                                : Echarts(
                                    option: c.getData(),
                                  ),
                            height: 220.h,
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
                                    c.rankList[index]['user_id'],
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
