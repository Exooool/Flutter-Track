import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/project_card.dart';
import '../components/custom_appbar.dart';
import '';

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

  // 自定义tab样式
  Widget _customTab(String content,
      {bool show = true, double opcity = 1, bool isMini = false}) {
    return Opacity(
        opacity: opcity,
        child: Container(
          padding: EdgeInsets.only(
              top: isMini ? 8 : 14,
              bottom: isMini ? 8 : 14,
              left: isMini ? 16 : 22,
              right: isMini ? 16 : 22),
          decoration: show
              ? BoxDecoration(
                  boxShadow:
                      opcity == 0.5 ? null : [MyWidgetStyle.mainBoxShadow],
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  gradient: MyWidgetStyle.mainLinearGradient)
              : null,
          child: Text(
            content,
            style: MyFontStyle.projectTab,
          ),
        ));
  }

  // 添加按钮
  Widget projectAddButton() {
    return Opacity(
        opacity: 0.6,
        child: Container(
            height: 72,
            width: 72,
            margin: const EdgeInsets.only(top: 6, bottom: 6),
            decoration: const BoxDecoration(
                boxShadow: [MyWidgetStyle.mainBoxShadow],
                borderRadius: BorderRadius.all(Radius.circular(60)),
                gradient: MyWidgetStyle.mainLinearGradient),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/add_project');
              },
              child: const Icon(
                Icons.add,
                color: MyColor.fontWhite,
                size: 36,
              ),
            )));
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

  @override
  void initState() {
    super.initState();
    _tabExteriorController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    _tabInteriorController =
        TabController(length: 3, vsync: this, initialIndex: 0);
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
              top: MediaQueryData.fromWindow(window).padding.top + 10),
          height: 60,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(90)),
              gradient: MyWidgetStyle.mainLinearGradientO4),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: TabBar(
                isScrollable: true,
                onTap: (e) {
                  setState(() {});
                },
                labelPadding: const EdgeInsets.only(left: 6, right: 6),
                controller: _tabExteriorController,
                indicator: const BoxDecoration(color: Colors.transparent),
                indicatorWeight: 0,
                tabs: [
                  _customTab('计划列表',
                      show: _tabExteriorController.index == 0 ? true : false),
                  _customTab('互助小组',
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
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    child: TabBar(
                      isScrollable: true,
                      onTap: (e) {
                        setState(() {});
                      },
                      indicator: const BoxDecoration(color: Colors.transparent),
                      indicatorWeight: 0,
                      labelPadding: const EdgeInsets.only(left: 6, right: 6),
                      controller: _tabInteriorController,
                      tabs: [
                        _customTab('进行中',
                            opcity: _tabInteriorController.index == 0 ? 1 : 0.5,
                            isMini: true),
                        _customTab('已完成',
                            opcity: _tabInteriorController.index == 1 ? 1 : 0.5,
                            isMini: true),
                        _customTab('全部',
                            opcity: _tabInteriorController.index == 2 ? 1 : 0.5,
                            isMini: true),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                          // 禁止滑动
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabInteriorController,
                          children: <Widget>[
                        ListView(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 100),
                          children: [
                            Column(
                              children: _getProject(),
                            ),
                            Column(
                              children: [projectAddButton()],
                            )
                          ],
                        ),
                        const Text('2'),
                        const Text('2')
                      ]))
                ],
              ),
              const Text('2')
            ])),
      ],
    );
  }
}
