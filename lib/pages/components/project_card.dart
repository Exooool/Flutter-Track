import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/custom_checkbox.dart';
import 'package:flutter_track/pages/components/custom_dialog.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/project/project_study.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final DateTime now = DateTime.now();
  final int type; //0表示默认在project页能删除和修改计划、1表示在个人页展示只能设置可见与不可见，2表示在他人主页不能进行任何操作
  late String stage;
  late int nowStage;
  late int projectLength;
  late Function? delete;
  late Function? change;

  ProjectCard(this.project,
      {Key? key, required this.type, this.delete, this.change})
      : super(key: key);

  // 设置对外或对自己可见
  setSecret(secret) {
    DioUtil().post('/project/secret',
        data: {'secret': secret, 'project_id': project.projectId},
        success: (res) {
      print(res);
      Get.back();
      Get.snackbar('提示', '修改成功');
      UserController u = Get.find();
      u.getUserInfo();
    }, error: (error) {
      print(error);
    });
  }

  // 检查当前处于那个阶段
  checkStage() {
    int totalStage = project.stageList.length;
    nowStage = totalStage;

    if (project.stageList[0]['endTime'] != null) {
      // 这是分了阶段的判断
      for (var i = 0; i < totalStage; i++) {
        DateTime set = DateTime.parse(project.stageList[i]['endTime']);
        if (set.isAfter(now)) {
          // 如果第i阶段的截止时间比现在的时间大，说明现在处于第i阶段
          nowStage = i + 1;
          break;
        }
      }
    } else {
      // 这是没有分阶段的判断
      DateTime set = DateTime.parse(project.endTime);
      if (set.isAfter(now)) {
        nowStage = 1;
      }
    }

    stage = '阶段 $nowStage/$totalStage';

    DateTime start = project.createTime;
    DateTime end = DateTime.parse(project.endTime);

    projectLength = start.difference(end).inDays.abs() + 1;
    print('计划一共$projectLength天');

    // print(now);
    // print(project.stageList);
    // print(project.endTime);
    // print('当前时间: $now，现在处于$nowStage/$totalStage');
  }

  // 检查是否到了可以学习的时间
  bool checkTime() {
    DateTime now = DateTime.now();
    Map m = project.stageList[0];
    DateTime time;
    if (m.isNotEmpty) {
      // print(m['frequency']['time']);
      time = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(m['frequency']['time'].substring(0, 2)),
          int.parse(m['frequency']['time'].substring(3, 5)));
    } else {
      Map temp = project.frequency;
      time = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(temp['time'].substring(0, 2)),
          int.parse(temp['time'].substring(3, 5)));
      // print(temp['time']);
    }

    print(time.difference(now).inHours);
    // 判断创建时间是否小于一个小时，小于放在projectlist1，否则放在projectlist2
    if (time.difference(now).inHours.abs() < 1) {
      return true;
    } else {
      return false;
    }
  }

  String frequency() {
    final week = ['一', '二', '三', '四', '五', '六', '日'];

    String listConcat(data) {
      String str = '';
      List list = data;
      if (list.length == 7) {
        str = '每天 ';
      } else {
        for (var i = 0; i < list.length; i++) {
          str += ' ' + week[list[i]];
        }
      }
      return str;
    }

    if (project.stageList[0]['endTime'] != null) {
      return listConcat(project.stageList[nowStage - 1]['frequency']['week']) +
          project.stageList[nowStage - 1]['frequency']['time'];
    } else {
      return listConcat(project.frequency['week']) + project.frequency['time'];
    }
  }

  Widget longPressDialog() {
    bool secret = project.secret == 'true';
    return SizedBox(
      height: 266.h,
      child: BlurWidget(Column(
        children: <Widget>[
          PublicCard(
              padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 17.w),
              margin: EdgeInsets.only(
                  left: 36.w, right: 36.w, top: 24.h, bottom: 20.h),
              radius: 90.r,
              widget: Row(
                children: <Widget>[
                  PublicCard(
                    radius: 90.r,
                    height: 50.r,
                    width: 50.r,
                    widget: Center(
                      child: project.projectImg.contains('http')
                          ? ClipOval(
                              child: Image.network(
                              project.projectImg,
                              height: 60.r,
                              width: 60.r,
                              fit: BoxFit.cover,
                            ))
                          : Image.asset('lib/assets/images/project' +
                              project.projectImg +
                              '.png'),
                    ),
                  ),
                  SizedBox(width: 17.w),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      project.projectTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: MyFontSize.font18,
                          fontFamily: MyFontFamily.pingfangRegular,
                          color: MyColor.fontBlack),
                    ),
                  ),
                ],
              )),
          type == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(children: <Widget>[
                      PublicCard(
                          radius: 90.r,
                          height: 72.r,
                          width: 72.r,
                          onTap: () {
                            change!(project.projectId);
                            Get.back();
                          },
                          margin: EdgeInsets.only(bottom: 8.h),
                          widget: Center(
                            child: Image.asset('lib/assets/icons/Pen_fill.png',
                                height: 44.r, width: 44.r),
                          )),
                      Text('修改计划',
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              fontFamily: MyFontFamily.pingfangRegular))
                    ]),
                    SizedBox(width: 24.w),
                    Column(
                      children: [
                        PublicCard(
                            radius: 90.r,
                            height: 72.r,
                            width: 72.r,
                            onTap: () {
                              Get.back();
                              delete!([project.projectId, project.groupId]);
                            },
                            margin: EdgeInsets.only(bottom: 8.h),
                            widget: Center(
                              child: Image.asset('lib/assets/icons/Trash.png',
                                  height: 44.r, width: 44.r),
                            )),
                        Text('删除计划',
                            style: TextStyle(
                                fontSize: MyFontSize.font16,
                                fontFamily: MyFontFamily.pingfangRegular))
                      ],
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    PublicCard(
                        radius: 90.r,
                        onTap: () {
                          print('设置为对外可见');
                          setSecret('false');
                        },
                        margin: EdgeInsets.only(
                            left: 36.w, right: 36.w, bottom: 12.h),
                        padding: EdgeInsets.only(left: 12.w, right: 12.w),
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('对外可见',
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    fontFamily: MyFontFamily.pingfangRegular)),
                            CustomCheckBox(
                                value: !secret,
                                onChanged: (value) {
                                  print(value);
                                })
                          ],
                        )),
                    PublicCard(
                        radius: 90.r,
                        onTap: () {
                          print('设置为自己可见');
                          setSecret('true');
                        },
                        margin: EdgeInsets.only(
                            left: 36.w, right: 36.w, bottom: 12.h),
                        padding: EdgeInsets.only(left: 12.w, right: 12.w),
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('自己可见',
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    fontFamily: MyFontFamily.pingfangRegular)),
                            CustomCheckBox(
                                value: secret,
                                onChanged: (value) {
                                  print(value);
                                })
                          ],
                        ))
                  ],
                )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 计算当前阶段
    checkStage();

    return PublicCard(
        height: 72.h,
        radius: 90.r,
        onTap: () {
          // 判断是否到达了指定时间
          if (type == 0 && checkTime()) {
            Get.to(() => ProjectStudy(), arguments: {'project': project});
          } else if (type == 0 && !checkTime()) {
            Get.dialog(
              CustomDialog(
                height: 330.h,
                width: 318.w,
                title: '提示',
                content: '还没有到你规定的学习时间！',
                subContent: '还不能进行学习！',
                onCancel: () {
                  Get.back();
                },
                onConfirm: () {
                  Get.back();
                },
              ),
              barrierColor: Colors.transparent,
            );
          }
        },
        onLongPress: () {
          if (type != 2) {
            Get.bottomSheet(longPressDialog(),
                barrierColor: Colors.transparent);
          }
        },
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
        widget: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // 头像
                  Stack(
                    children: [
                      PublicCard(
                        radius: 90.r,
                        height: 60.r,
                        width: 60.r,
                        widget: Center(
                          child: project.projectImg.contains('http')
                              ? ClipOval(
                                  child: Image.network(
                                  project.projectImg,
                                  height: 60.r,
                                  width: 60.r,
                                  fit: BoxFit.cover,
                                ))
                              : Image.asset('lib/assets/images/project' +
                                  project.projectImg +
                                  '.png'),
                        ),
                      ),
                      Visibility(
                          visible: project.groupId != null ? true : false,
                          child: Positioned(
                              bottom: 0,
                              right: 0,
                              child: PublicCard(
                                  radius: 90.r,
                                  widget: Image.asset(
                                    'lib/assets/images/group.png',
                                    width: 18.r,
                                    height: 22.r,
                                  ))))
                    ],
                  ),
                  // 计划信息
                  Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 190.w,
                          child: Text(
                            project.projectTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: MyFontSize.font18,
                                fontFamily: MyFontFamily.pingfangRegular,
                                color: MyColor.fontBlack),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            type == 0
                                ? Text(stage,
                                    style: TextStyle(
                                        fontSize: MyFontSize.font12,
                                        color: MyColor.fontBlack))
                                : Container(),
                            type == 1
                                ? Image.asset(
                                    'lib/assets/icons/Time_fill.png',
                                    height: 24.r,
                                    width: 24.r,
                                  )
                                : Container(),
                            SizedBox(width: type == 0 ? 12.w : 3.w),
                            Text(frequency(),
                                style: TextStyle(
                                    fontSize: type == 0
                                        ? MyFontSize.font12
                                        : MyFontSize.font14,
                                    fontFamily: MyFontFamily.pingfangRegular,
                                    color: MyColor.fontBlack))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Center(
                // 圆形进度条
                child: CircularPercentIndicator(
                  radius: 36.r,
                  lineWidth: 10.r,
                  percent:
                      (project.studyTime.length ~/ projectLength).toDouble(),
                  center: Text(
                    "${(project.studyTime.length ~/ projectLength) * 100}%",
                    style: TextStyle(
                      fontSize: MyFontSize.font16,
                      color: MyColor.fontBlack,
                      fontFamily: MyFontFamily.sfDisplaySemibold,
                    ),
                  ),
                  startAngle: 270.0,
                  linearGradient: MyWidgetStyle.mainLinearGradient,
                  backgroundColor: const Color.fromRGBO(107, 101, 244, 0.2),
                ),
              )
            ],
          ),
        ));
  }
}
