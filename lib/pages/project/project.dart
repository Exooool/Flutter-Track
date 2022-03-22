import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/project_card.dart';
import 'package:flutter_track/pages/components/public_card.dart';

// 测试数据
import 'package:flutter_track/assets/test.dart';

// 样式导入
import 'package:flutter_track/common/style/my_style.dart';

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

  Map groupList = {'matched': [], 'matching': []};
  List projectList = [];
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
          child: Image.asset('lib/assets/icons/Add.png',
              height: 44.r, width: 44.r),
        ));
  }

  // 获取计划
  List<Widget> _getProject() {
    List<Widget> list = [];
    var l = projectData['project'] as List<dynamic>;
    list = l.map((e) {
      return ProjectCard(Project.fromMap(e));
    }).toList();
    return list;
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // ElevatedButton(
        //     onPressed: () {
        //       // var maplist = jsonDecode(data.toString());
        //       var json = data['data'] as Map;
        //       // print(Article.fromMap(json));
        //       print(Article.fromMap(json['news'][0]));
        //     },
        //     child: Text('click'))

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
                        top: 35.h, left: 24.w, right: 24.w, bottom: 100.h),
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
                      Column(
                        children: _getProject(),
                      ),
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
                      Column(
                        children: _getProject(),
                      ),
                      Center(child: projectAddButton())
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
                        groupList['matched'].isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text('暂无互助小组'),
                                  Text('快去添加计划试试吧～')
                                ],
                              )
                            : ListView(
                                children: const [],
                              ),
                        groupList['matching'].isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text('暂无互助小组'),
                                  Text('快去添加计划试试吧～')
                                ],
                              )
                            : ListView(
                                children: const [],
                              ),
                      ]))
                ],
              ),
            ])),
      ],
    );
  }
}
