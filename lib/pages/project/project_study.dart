import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_dialog.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class ProjectStudyController extends GetxController {
  final Project project = Get.arguments['project'];
  RxInt show = 0.obs; // 展示第几个用户的学习信息
  RxInt totalSingleTime = 0.obs; // 总的单次时长 以秒为单位
  RxInt singleTime = 0.obs; // 用来给timer计算的单次时长 以秒为单位
  RxString content = ''.obs;
  RxList groupUserList = [].obs;
  late Timer timer;
  late int nowStage;

  // 初始化
  _getInit() {
    if (project.groupId != null) {
      DioUtil().post('/project/group/getById',
          data: {'group_id': project.groupId}, success: (res) {
        print(res);
        groupUserList.value = res['data'];
      }, error: (error) {
        print(error);
      });
    }
    debugPrint('${project.nowStage()}');
    nowStage = project.nowStage();
    // 转换单次时长
    // 获取当前阶段的内容
    if (project.singleTime.isEmpty) {
      totalSingleTime.value = singleTime.value =
          project.singleTimeTf(project.stageList[nowStage - 1]['singleTime']) *
              60;
      content.value = project.stageList[nowStage - 1]['content'];
    } else {
      totalSingleTime.value =
          singleTime.value = project.singleTimeTf(project.singleTime) * 60;
    }

    debugPrint('当前单次时长为：$singleTime');

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      singleTime.value--;
      if (singleTime.value == 0) {
        t.cancel();
      }
    });
  }

  // 补零
  addZero(value) {
    if (value < 10) {
      return '0$value';
    }
    return value;
  }

  // 获取他人学习时长
  getOtherSingleTime(Map<String, dynamic> map) {
    Project p = Project.fromMap(map);
    if (project.singleTime.isEmpty) {
      return p.singleTimeTf(project.stageList[p.nowStage() - 1]['singleTime']);
    } else {
      return p.singleTimeTf(project.singleTime);
    }
  }

  // 计算当前学习时间 并上传至数据库
  checkStudyTime() {
    // 关闭定时器
    // timer.cancel();
    int studyTime = (totalSingleTime.value - singleTime.value) ~/ 60;
    // 小于1就退出
    if (studyTime < 1) {
      Get.back();
      Get.back();
      return;
    }
    String dateTime = DateTime.now().toString().substring(0, 10);
    DioUtil().post('/project/study', data: {
      'study_time': studyTime,
      'now_time': dateTime,
      'project_id': project.projectId
    }, success: (res) {
      print(res);
      // 第一次back退出dialog
      Get.back();
      // 第二次退出计时
      Get.back();
      if (res['status'] == 0) {
        Get.dialog(
            CustomDialog(
              height: 330.h,
              width: 318.w,
              title: '提示',
              content: '数据上传成功',
              subContent: '您本次学习时间为：$studyTime',
            ),
            barrierColor: Colors.transparent);
      } else {
        Get.dialog(
            CustomDialog(
              height: 330.h,
              width: 318.w,
              title: '提示',
              content: '数据上传异常',
            ),
            barrierColor: Colors.transparent);
      }
    }, error: (error) {
      print(error);
    });

    // debugPrint('学习时长为：$studyTime 分钟');
  }

  @override
  void onInit() {
    super.onInit();
    _getInit();
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }
}

class ProjectStudy extends StatelessWidget {
  ProjectStudy({
    Key? key,
  }) : super(key: key);

  final ProjectStudyController c = Get.put(ProjectStudyController());

  Widget userItem(Map<String, dynamic> map, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 7.5.w, right: 7.5.w, bottom: 12.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          InkWell(
            onTap: () {
              c.show.value = index;
            },
            child: ClipOval(
                child: map['user_img'] == ''
                    ? Image.asset(
                        'lib/assets/images/defaultUserImg.png',
                        height: 48.r,
                        width: 48.r,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        map['user_img'],
                        height: 48.r,
                        width: 48.r,
                        fit: BoxFit.cover,
                      )),
          ),
          Positioned(
              bottom: -90.r,
              left: c.show.value == 1 ? -160.r : 20.r,
              child: Visibility(
                  visible: c.show.value == index ? true : false,
                  child: PublicCard(
                    radius: 10.r,
                    padding: EdgeInsets.only(
                        top: 6.h, bottom: 6.h, left: 30.w, right: 30.w),
                    widget: Column(
                      children: <Widget>[
                        Text(map['project_title'],
                            style: TextStyle(fontSize: MyFontSize.font12)),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, bottom: 12.h),
                          child: Text('时长 ${c.getOtherSingleTime(map)}m',
                              style: TextStyle(fontSize: MyFontSize.font12)),
                        ),
                        PublicCard(
                            radius: 90.r,
                            padding: EdgeInsets.only(
                                left: 13.w, right: 13.w, top: 5.h, bottom: 5.h),
                            widget: Text('访问主页',
                                style: TextStyle(fontSize: MyFontSize.font12)))
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  getUser() {
    List<Widget> list = [];
    for (var i = 0; i < c.groupUserList.length; i++) {
      list.add(userItem(c.groupUserList[i], i + 1));
    }
    return list;
  }

  // 弹窗提醒
  showDialog() {
    Get.dialog(
      CustomDialog(
        height: 330.h,
        width: 318.w,
        title: '提示',
        content: '您确定要退出吗！中途退出可能不计算学习时间！',
        subContent: '若时间小于一分钟则不计时长！',
        onCancel: () {
          Get.back();
        },
        onConfirm: () {
          c.checkStudyTime();
        },
      ),
      barrierColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar('',
            title: '正在倒计时',
            leading: InkWell(
              onTap: () => showDialog(),
              child: Image.asset(
                'lib/assets/icons/Refund_back.png',
                height: 25.r,
                width: 25.r,
              ),
            )),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            debugPrint('点击外侧');
            c.show.value = 0;
          },
          child: WillPopScope(
            onWillPop: () async {
              showDialog();
              return false;
            },
            child: GetX<ProjectStudyController>(builder: (_) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 160.h),
                      // 倒计时界面
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              'lib/assets/images/timer.png',
                              height: 306.r,
                              width: 306.r,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                child: Container(
                              height: 306.r,
                              width: 306.r,
                              alignment: Alignment.center,
                              child: Text(
                                '${c.addZero(c.singleTime ~/ 3600)}:${c.addZero((c.singleTime ~/ 60) % 60)}:${c.addZero(c.singleTime % 60)}',
                                style: TextStyle(
                                    fontSize: MyFontSize.font20,
                                    foreground:
                                        MyFontStyle.textlinearForeground,
                                    fontWeight: FontWeight.w700),
                              ),
                            ))
                          ],
                        ),
                      ),

                      // 计划名称
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 21.h),
                        child: Text(
                          c.project.projectTitle,
                          style: TextStyle(
                              fontSize: MyFontSize.font18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      // 计划阶段
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: Text(
                          '阶段${c.project.nowStage()}/${c.project.stageList.length}',
                          style: TextStyle(
                              fontSize: MyFontSize.font18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      // 当前阶段内容
                      Center(
                        child: Text(
                          c.content.value,
                          style: TextStyle(
                              fontSize: MyFontSize.font14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),

                      // 关闭按钮
                    ],
                  ),
                  Positioned(
                    top: 0,
                    child:
                        // 小组成员
                        Container(
                      width: MediaQueryData.fromWindow(window).size.width,
                      alignment: Alignment.center,
                      child: c.groupUserList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 74.h),
                              child: Stack(
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: getUser(),
                                      ),
                                      Center(
                                        child: Text(
                                          '点击头像可查看组员信息',
                                          style: TextStyle(
                                              fontSize: MyFontSize.font12,
                                              color: MyColor.fontGrey),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  ),

                  // 关闭按钮
                  Positioned(
                      bottom: 44.h,
                      child: Container(
                        width: MediaQueryData.fromWindow(window).size.width,
                        alignment: Alignment.center,
                        child: PublicCard(
                          radius: 90.r,
                          height: 48.r,
                          width: 48.r,
                          // 退出前进行弹窗提醒
                          onTap: () => showDialog(),
                          widget: Center(
                            child: Image.asset(
                              'lib/assets/icons/Close.png',
                              height: 33.r,
                              width: 33.r,
                            ),
                          ),
                        ),
                      ))
                ],
              );
            }),
          ),
        ));
  }
}
