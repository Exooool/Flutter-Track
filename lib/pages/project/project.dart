import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  List groupListMatched = [{}];
  List groupListMatching = [];
  List projectList1 = [];
  List projectList2 = [];
  // 自定义tab样式
  Widget mainTab(String content, {bool show = true}) {
    return show
        ? PublicCard(
            height: 48.h,
            width: 124.w,
            notWhite: true,
            radius: 90.r,
            widget: Center(
              child: Text(
                content,
                style: MyFontStyle.projectTabSelected,
              ),
            ))
        : Container(
            height: 48.h,
            width: 124.w,
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
                    fontSize: MyFontSize.font14, color: MyColor.fontBlack),
              ),
            ))
        : Container(
            height: 36.h,
            width: 76.w,
            alignment: Alignment.center,
            child: Text(
              content,
              style: TextStyle(
                  fontSize: MyFontSize.font14, color: MyColor.fontBlackO2),
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

  // 获取计划
  // List<Widget> _getProject() {
  //   List<Widget> list = [];
  //   var l = projectData['project'] as List<dynamic>;
  //   list = l.map((e) {
  //     return ProjectCard(Project.fromMap(e));
  //   }).toList();
  //   return list;
  // }

  _getProject() {
    DioUtil().post('/project/get', success: (res) {
      // print(res);
      // setState(() {
      //   list = res['data'];
      // });

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
      setState(() {});
    }, error: (error) {
      print(error);
    });
  }

  // List<Widget> _getGroup(List list) {
  //   if (list.isEmpty) {
  //     return;
  //   } else {
  //     return;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _tabExteriorController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    _tabInteriorController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    _getProject();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: MediaQueryData.fromWindow(window).padding.top + 12.h),
          child: PublicCard(
            height: 60.h,
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
                            child: Text(
                              '即将开始',
                              style: TextStyle(fontSize: MyFontSize.font14),
                            ),
                          ),
                        ),
                      ),
                      projectList1.isEmpty
                          ? const Center(child: Text('显示60分钟内将进行的计划'))
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: projectList1.length,
                              itemBuilder: (context, index) {
                                return ProjectCard(
                                  Project.fromMap(projectList1[index]),
                                  delete: (id) {
                                    DioUtil().post('/project/remove',
                                        data: {'project_id': id},
                                        success: (res) {
                                      print(res);

                                      _getProject();
                                      Get.snackbar('提示', '删除成功');
                                    }, error: (error) {
                                      print(error);
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
                              style: TextStyle(fontSize: MyFontSize.font14),
                            ),
                          ),
                        ),
                      ),
                      projectList2.isEmpty
                          ? Center(
                              child: Column(
                              children: const [
                                Text('暂无计划'),
                                Text('快添加计划试试吧～'),
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
                                  delete: (id) {
                                    DioUtil().post('/project/remove',
                                        data: {'project_id': id},
                                        success: (res) {
                                      print(res);

                                      _getProject();
                                      Get.snackbar('提示', '删除成功');
                                    }, error: (error) {
                                      print(error);
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
                                children: const [
                                  Text('暂无互助小组'),
                                  Text('快去添加计划试试吧～')
                                ],
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: groupListMatched.length,
                                itemBuilder: (context, index) {
                                  return GroupCard();
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
                                  return GroupCard();
                                }),
                      ]))
                ],
              ),
            ])),
      ],
    );
  }
}
