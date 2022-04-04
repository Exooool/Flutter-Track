import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/group_card.dart';
import 'package:flutter_track/pages/components/project_card.dart';
import 'package:flutter_track/pages/components/public_card.dart';

// 样式导入
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key? key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  // 外层tab的controller
  late TabController _tabExteriorController;
  // 内层tab的controller
  late TabController _tabInteriorController;

  // 匹配成功的队列
  List groupListMatched = [];
  // 正在匹配的队列
  List groupListMatching = [];
  // 60分钟内进行的计划
  List projectList1 = [];
  // 其余计划
  List projectList2 = [];
  // 自定义tab样式
  Widget mainTab(String content, {bool show = true}) {
    return show
        ? PublicCard(
            padding: EdgeInsets.only(
                left: 27.w, right: 27.w, top: 13.h, bottom: 13.h),
            notWhite: true,
            radius: 90.r,
            widget: Center(
              child: Text(
                content,
                style: MyFontStyle.projectTabSelected,
              ),
            ))
        : Container(
            padding: EdgeInsets.only(
                left: 27.w, right: 27.w, top: 13.h, bottom: 13.h),
            alignment: Alignment.center,
            child: Text(
              content,
              style: MyFontStyle.projectTabUnSelected,
            ),
          );
  }

  // 副tab
  Widget subTab(String content, {bool show = true}) {
    return show
        ? PublicCard(
            radius: 90.r,
            height: 36.h,
            width: 76.w,
            widget: Center(
              child: Text(
                content,
                style: TextStyle(
                    fontSize: MyFontSize.font14,
                    color: MyColor.fontBlack,
                    fontFamily: MyFontFamily.pingfangRegular),
              ),
            ))
        : Container(
            height: 36.h,
            width: 76.w,
            alignment: Alignment.center,
            child: Text(
              content,
              style: TextStyle(
                  fontSize: MyFontSize.font14,
                  color: MyColor.fontBlackO2,
                  fontFamily: MyFontFamily.pingfangRegular),
            ),
          );
  }

  // 添加按钮
  Widget projectAddButton() {
    return PublicCard(
        height: 72.r,
        width: 72.r,
        radius: 60.r,
        margin: EdgeInsets.only(top: 24.h),
        widget: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/add_project');
          },
          child: Center(
            child: Image.asset('lib/assets/icons/Add.png',
                height: 44.r, width: 44.r),
          ),
        ));
  }

  _getProject() {
    DioUtil().post('/project/get', success: (res) {
      print('计划列表$res');

      // 清空数据 然后请求替换数据
      projectList1 = [];
      projectList2 = [];

      DateTime now = DateTime.now();
      List list = res['data'];
      for (var i = 0; i < list.length; i++) {
        DateTime time = DateTime.parse(list[i]['create_time']);
        // print(time.difference(now).inHours);
        // 判断创建时间是否小于一个小时，小于放在projectlist1，否则放在projectlist2
        if (time.difference(now).inHours.abs() < 1) {
          projectList1.add(list[i]);
        } else {
          projectList2.add(list[i]);
        }
      }
      if (mounted) {
        setState(() {});
      }
    }, error: (error) {
      print(error);
    });
  }

  // 获取互助小组信息
  _getGroup() {
    DioUtil().get('/project/group/get', success: (res) {
      print('互助小组信息$res');
      List groupInfo = res['data'];
      Map<int, List> m = {};
      // 对获取的数据进行解析
      // 解析到map中
      for (int i = 0; i < groupInfo.length; i++) {
        if (m[groupInfo[i]['group_id']] == null) {
          List l = [];
          l.add(groupInfo[i]);
          m[groupInfo[i]['group_id']] = l;
        } else {
          m[groupInfo[i]['group_id']]!.add(groupInfo[i]);
        }
      }
      // 在通过map的key的list类型的长度来判断是不是在匹配中
      debugPrint('----------------------');
      // 格式化列表
      groupListMatched = [];
      groupListMatching = [];
      for (int i = 0; i < m.length; i++) {
        if (m[m.keys.toList()[i]]!.length < 3) {
          groupListMatching.add(m[m.keys.toList()[i]]);
        } else {
          groupListMatched.add(m[m.keys.toList()[i]]);
        }
      }
      if (mounted) {
        setState(() {});
      }
      debugPrint('匹配成功列表：$groupListMatched');
      debugPrint('匹配中列表：$groupListMatching');
      // print(m);
    }, error: (error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabExteriorController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    _tabInteriorController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    _getProject();
    _getGroup();
  }

  @override
  Widget build(BuildContext context) {
    final JPush jpush = JPush();
    jpush.applyPushAuthority();
    jpush.setup(
      appKey: "7c512da646446cc69f9c55a5", // 极光中的appkey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
      debugPrint("接收到推送: $message");
    }, onOpenNotification: (Map<String, dynamic> message) async {
      debugPrint("通过点击推送进入app: $message");
    }, onReceiveMessage: (Map<String, dynamic> message) async {
      debugPrint("接收到自定义消息: $message");
    }, onReceiveNotificationAuthorization:
            (Map<String, dynamic> message) async {
      debugPrint("通知权限状态: $message");
    });
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: MediaQueryData.fromWindow(window).padding.top + 12.h),
          child: PublicCard(
            padding: EdgeInsets.all(6.r),
            radius: 90.r,
            widget: TabBar(
                isScrollable: true,
                onTap: (e) {
                  setState(() {});
                },
                labelPadding: EdgeInsets.only(left: 6.w, right: 6.w),
                controller: _tabExteriorController,
                indicator: const BoxDecoration(color: Colors.transparent),
                indicatorWeight: 0,
                tabs: [
                  mainTab('计划列表',
                      show: _tabExteriorController.index == 0 ? true : false),
                  mainTab('互助小组',
                      show: _tabExteriorController.index == 1 ? true : false),
                ]),
          ),
        ),
        Expanded(
            child: TabBarView(
                // 禁止滑动
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabExteriorController,
                children: <Widget>[
              // 计划列表
              Stack(
                children: [
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 35.h, left: 24.w, right: 24.w, bottom: 150.h),
                    children: [
                      Center(
                        child: PublicCard(
                          margin: EdgeInsets.only(bottom: 20.h),
                          width: 96.w,
                          height: 36.h,
                          radius: 90.r,
                          widget: Center(
                            child: Text('即将开始',
                                style: TextStyle(
                                    fontSize: MyFontSize.font14,
                                    fontFamily: MyFontFamily.pingfangRegular)),
                          ),
                        ),
                      ),
                      projectList1.isEmpty
                          ? Center(
                              child: Text('显示60分钟内将进行的计划',
                                  style: TextStyle(
                                      fontSize: MyFontSize.font16,
                                      fontFamily:
                                          MyFontFamily.pingfangRegular)))
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: projectList1.length,
                              itemBuilder: (context, index) {
                                return ProjectCard(
                                  Project.fromMap(projectList1[index]),
                                  delete: (list) {
                                    DioUtil().post('/project/remove', data: {
                                      'project_id': list[0],
                                      'group_id': list[1]
                                    }, success: (res) {
                                      print(res);

                                      _getProject();
                                      _getGroup();
                                      Get.snackbar('提示', '删除成功');
                                    }, error: (error) {
                                      Get.snackbar('提示', error);
                                    });
                                  },
                                  change: () {},
                                  type: 0,
                                );
                              }),
                      Center(
                        child: PublicCard(
                          margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                          radius: 90.r,
                          width: 96.w,
                          height: 36.h,
                          widget: Center(
                            child: Text(
                              '其余计划',
                              style: TextStyle(
                                  fontSize: MyFontSize.font14,
                                  fontFamily: MyFontFamily.pingfangRegular),
                            ),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       jpush.getRegistrationID().then((rid) {
                      //         print("当前设备的rid： ${rid}");
                      //       });
                      //       var fireDate = DateTime.fromMillisecondsSinceEpoch(
                      //           DateTime.now().millisecondsSinceEpoch + 3000);
                      //       var localNotification = LocalNotification(
                      //           id: 234,
                      //           title: "本地推送",
                      //           buildId: 1,
                      //           content:
                      //               "😁 随便写点内容，时间 ${DateTime.now().toIso8601String()}",
                      //           fireTime: DateTime.now(), // 立即发送
                      //           subtitle: "副标题 123456",
                      //           extra: {"myInfo": "推送信息balabla"} // 携带数据
                      //           );
                      //       jpush.sendLocalNotification(localNotification);
                      //     },
                      //     child: Text('123')),
                      projectList2.isEmpty
                          ? Center(
                              child: Column(
                              children: [
                                Text('暂无计划',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font16,
                                        fontFamily:
                                            MyFontFamily.pingfangRegular)),
                                Text('快添加计划试试吧～',
                                    style: TextStyle(
                                        fontSize: MyFontSize.font16,
                                        fontFamily:
                                            MyFontFamily.pingfangRegular)),
                              ],
                            ))
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: projectList2.length,
                              itemBuilder: (context, index) {
                                return ProjectCard(
                                  Project.fromMap(projectList2[index]),
                                  delete: (list) {
                                    DioUtil().post('/project/remove', data: {
                                      'project_id': list[0],
                                      'group_id': list[1]
                                    }, success: (res) {
                                      print(res);

                                      _getProject();
                                      _getGroup();
                                      Get.snackbar('提示', '删除成功');
                                    }, error: (error) {
                                      Get.snackbar('提示', error);
                                    });
                                  },
                                  change: () {},
                                  type: 0,
                                );
                              }),
                      Center(child: projectAddButton()),
                    ],
                  ),
                ],
              ),

              // 互助小组
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 60.h,
                    child: TabBar(
                      isScrollable: true,
                      onTap: (e) {
                        setState(() {});
                      },
                      indicator: const BoxDecoration(color: Colors.transparent),
                      indicatorWeight: 0,
                      labelPadding: EdgeInsets.only(left: 6.w, right: 6.w),
                      controller: _tabInteriorController,
                      tabs: [
                        subTab('匹配成功',
                            show: _tabInteriorController.index == 0
                                ? true
                                : false),
                        subTab('匹配中',
                            show: _tabInteriorController.index == 1
                                ? true
                                : false),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                          // 禁止滑动
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabInteriorController,
                          children: <Widget>[
                        groupListMatched.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('暂无互助小组',
                                      style: TextStyle(
                                          fontSize: MyFontSize.font16,
                                          fontFamily:
                                              MyFontFamily.pingfangRegular)),
                                  Text('快去添加计划试试吧～',
                                      style: TextStyle(
                                          fontSize: MyFontSize.font16,
                                          fontFamily:
                                              MyFontFamily.pingfangRegular))
                                ],
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: groupListMatched.length,
                                itemBuilder: (context, index) {
                                  return GroupCard(groupListMatched[index],
                                      delete: (groupId) {
                                    DioUtil().post('/project/group/remove',
                                        data: {'group_id': groupId},
                                        success: (res) {
                                      print(res);
                                    }, error: (error) {
                                      print(error);
                                    });

                                    _getGroup();
                                  });
                                }),
                        groupListMatching.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text('暂无互助小组'),
                                  Text('快去添加计划试试吧～')
                                ],
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: groupListMatching.length,
                                itemBuilder: (context, index) {
                                  return GroupCard(
                                    groupListMatching[index],
                                    delete: (groupId) {
                                      DioUtil().post('/project/group/remove',
                                          data: {'group_id': groupId},
                                          success: (res) {
                                        print(res);
                                        if (res['status'] == 0) {
                                          Get.snackbar('提示', '删除成功');
                                        }
                                      }, error: (error) {
                                        Get.snackbar('提示', error);
                                      });

                                      _getGroup();
                                    },
                                    type: false,
                                  );
                                }),
                      ]))
                ],
              ),
            ])),
      ],
    );
  }
}
