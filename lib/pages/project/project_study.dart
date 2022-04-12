import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_dialog.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:flutter_track/pages/user/user_model.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ProjectStudyController extends GetxController {
  final Project project = Get.arguments['project'];
  final UserController u = Get.find();
  late final io.Socket socket;
  RxInt show = 0.obs; // 展示第几个用户的学习信息
  RxInt totalSingleTime = 0.obs; // 总的单次时长 以秒为单位
  RxInt singleTime = 0.obs; // 用来给timer计算的单次时长 以秒为单位
  RxString content = ''.obs;
  RxList groupUserList = [].obs;
  RxMap onlineList = {}.obs;
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

      DioUtil().get('/chart/getOnlineList', success: (res) {
        debugPrint('当前在线列表$res');
        onlineList.value = res;
        print(onlineList);
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

  @override
  void onInit() {
    super.onInit();
    _getInit();

    socket = io.io(
        DioUtil.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();
    socket.onConnect((_) {
      socket.emit('join', '${u.user.value.userId}');
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    socket.close();
  }
}

class ProjectStudy extends StatelessWidget {
  ProjectStudy({
    Key? key,
  }) : super(key: key);

  final ProjectStudyController c = Get.put(ProjectStudyController());

  // 计算当前学习时间 并上传至数据库
  checkStudyTime() {
    // 关闭定时器
    // timer.cancel();
    int studyTime = (c.totalSingleTime.value - c.singleTime.value) ~/ 60;
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
      'project_id': c.project.projectId
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

  // 用户item
  Widget userItem(Map<String, dynamic> map, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 7.5.w, right: 7.5.w, bottom: 12.h),
      child: InkWell(
        onTap: () {
          c.show.value = index;
          // print(c.show);
        },
        child: Opacity(
          opacity: c.onlineList[jsonEncode(map['user_id'])] == null ? 0.2 : 1,
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
      ),
    );
  }

  // 用户小卡片
  Widget userTip() {
    int index = c.show.value - 1 == -1 ? 0 : c.show.value - 1;
    return Positioned(
      top: 60.r,
      left: index == 1
          ? MediaQueryData.fromWindow(window).size.width / 2 + 20.r
          : null,
      right: index == 0
          ? MediaQueryData.fromWindow(window).size.width / 2 + 20.r
          : null,
      child: Visibility(
          visible: c.show.value == 1 || c.show.value == 2 ? true : false,
          child: Center(
            child: PublicCard(
              radius: 10.r,
              padding: EdgeInsets.only(
                  top: 6.h, bottom: 6.h, left: 30.w, right: 30.w),
              widget: c.onlineList[
                          jsonEncode(c.groupUserList[index]['user_id'])] ==
                      null
                  ? Column(
                      children: <Widget>[
                        Text('不在线',
                            style: TextStyle(
                                fontSize: MyFontSize.font12,
                                fontFamily: MyFontFamily.pingfangRegular)),
                        SizedBox(height: 2.r),
                        PublicCard(
                            radius: 90.r,
                            onTap: () {
                              Get.snackbar('提示', '已发送提醒');
                              c.show.value = 0;
                            },
                            padding: EdgeInsets.only(
                                left: 13.w, right: 13.w, top: 5.h, bottom: 5.h),
                            widget: Text('点击提醒',
                                style: TextStyle(
                                    fontSize: MyFontSize.font12,
                                    fontFamily: MyFontFamily.pingfangRegular))),
                        PublicCard(
                            radius: 90.r,
                            onTap: () {
                              // print(c.groupUserList[index]['user_id']);
                              Get.to(() => UserModelPage(), arguments: {
                                'query_user_id': c.groupUserList[index]
                                    ['user_id']
                              });
                              c.show.value = 0;
                            },
                            padding: EdgeInsets.only(
                                left: 13.w, right: 13.w, top: 5.h, bottom: 5.h),
                            widget: Text('访问主页',
                                style: TextStyle(
                                    fontSize: MyFontSize.font12,
                                    fontFamily: MyFontFamily.pingfangRegular)))
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        Text(c.groupUserList[index]['project_title'],
                            style: TextStyle(fontSize: MyFontSize.font12)),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, bottom: 12.h),
                          child: Text(
                              '时长 ${c.getOtherSingleTime(c.groupUserList[index])}m',
                              style: TextStyle(
                                  fontSize: MyFontSize.font12,
                                  fontFamily: MyFontFamily.pingfangRegular)),
                        ),
                        PublicCard(
                            radius: 90.r,
                            onTap: () {
                              // print(c.groupUserList[index]['user_id']);
                              Get.to(() => UserModelPage(), arguments: {
                                'query_user_id': c.groupUserList[index]
                                    ['user_id']
                              });
                            },
                            padding: EdgeInsets.only(
                                left: 13.w, right: 13.w, top: 5.h, bottom: 5.h),
                            widget: Text('访问主页',
                                style: TextStyle(
                                    fontSize: MyFontSize.font12,
                                    fontFamily: MyFontFamily.pingfangRegular)))
                      ],
                    ),
            ),
          )),
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
          checkStudyTime();
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
              ScreenUtil.init(
                  BoxConstraints(
                      maxWidth: MediaQueryData.fromWindow(window).size.width,
                      maxHeight: MediaQueryData.fromWindow(window).size.height),
                  designSize: const Size(414, 896),
                  context: context,
                  minTextAdapt: true,
                  orientation: Orientation.portrait);
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
                                    fontFamily: MyFontFamily.sfDisplayBold,
                                    foreground:
                                        MyFontStyle.textlinearForeground),
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
                              fontFamily: MyFontFamily.pingfangSemibold),
                        ),
                      ),
                      // 计划阶段
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: Text(
                          '阶段${c.project.nowStage()}/${c.project.stageList.length}',
                          style: TextStyle(
                              fontSize: MyFontSize.font14,
                              fontFamily: MyFontFamily.pingfangMedium),
                        ),
                      ),
                      // 当前阶段内容
                      Center(
                        child: Text(
                          c.content.value,
                          style: TextStyle(
                              fontSize: MyFontSize.font12,
                              fontFamily: MyFontFamily.pingfangRegular),
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
                      height: 400.h,
                      alignment: Alignment.center,
                      child: c.groupUserList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 74.h),
                              child: Stack(
                                children: [
                                  // 头像列
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
                                              fontFamily:
                                                  MyFontFamily.pingfangRegular,
                                              color: MyColor.fontGrey),
                                        ),
                                      )
                                    ],
                                  ),
                                  userTip(),
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
