import 'dart:convert';

import 'package:percent_indicator/percent_indicator.dart';

import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
import 'package:flutter_track/model/project_model.dart';

// 测试数据
import 'package:flutter_track/assets/test.dart';

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
  Widget _customTab(String content, double opcity, {bool isMini = false}) {
    return Opacity(
        opacity: opcity,
        child: Container(
          padding: EdgeInsets.only(
              top: isMini ? 8 : 14,
              bottom: isMini ? 8 : 14,
              left: isMini ? 16 : 22,
              right: isMini ? 16 : 22),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(56, 86, 244, 0.4), // 阴影的颜色
                  offset: Offset(0, 6), // 阴影与容器的距离
                  blurRadius: 10, // 高斯的标准偏差与盒子的形状卷积。
                  spreadRadius: 0, // 在应用模糊之前，框应该膨胀的量。
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(60)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(107, 101, 244, 1),
                    Color.fromRGBO(51, 84, 244, 1)
                  ])),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ));
  }

  // 计划卡片
  Widget _projectCard(Project e) {
    return Container(
      height: 72,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.only(left: 16, right: 32),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(56, 86, 244, 0.4), // 阴影的颜色
              offset: Offset(0, 6), // 阴影与容器的距离
              blurRadius: 10, // 高斯的标准偏差与盒子的形状卷积。
              spreadRadius: 0, // 在应用模糊之前，框应该膨胀的量。
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(60)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(107, 101, 244, 1),
                Color.fromRGBO(51, 84, 244, 1)
              ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              // 头像
              CircleAvatar(
                backgroundColor: tfColor[e.iconInfo.color],
                child: const Icon(Icons.ac_unit),
              ),
              // 计划信息
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      e.projectTtile,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Text('(已加入小组)',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromRGBO(240, 242, 243, 0.5))),
                    Text(
                      e.stageList[0].reminderTime,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
          Center(
            // 圆形进度条
            child: CircularPercentIndicator(
              radius: 18.5,
              lineWidth: 5.0,
              percent: 0.1,
              center: const Text(
                "10%",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              startAngle: 270.0,
              progressColor: tfColor[e.iconInfo.color],
              backgroundColor: const Color.fromRGBO(240, 242, 243, 0.5),
              footer: const Text(
                '剩余270天',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 颜色对应
  Map<String, Color> tfColor = const {
    "fColor1": Color.fromRGBO(255, 128, 128, 1),
    "fColor2": Color.fromRGBO(255, 191, 128, 1),
    "fColor3": Color.fromRGBO(255, 255, 128, 1),
    "fColor4": Color.fromRGBO(191, 255, 128, 1),
    "fColor5": Color.fromRGBO(128, 255, 128, 1),
    "fColor6": Color.fromRGBO(128, 255, 191, 1),
    "fColor7": Color.fromRGBO(128, 255, 255, 1),
    "fColor8": Color.fromRGBO(128, 191, 255, 1),
    "fColor9": Color.fromRGBO(128, 128, 255, 1),
    "fColor10": Color.fromRGBO(191, 128, 255, 1),
    "fColor11": Color.fromRGBO(255, 128, 255, 1),
    "fColor12": Color.fromRGBO(255, 128, 191, 1),
    "fColor13": Color.fromRGBO(0, 0, 0, 1),
    "fColor14": Color.fromRGBO(255, 255, 255, 1),
  };

  // 添加按钮
  Widget projectAddButton() {
    return Opacity(
        opacity: 0.6,
        child: Container(
            height: 72,
            margin: const EdgeInsets.only(top: 6, bottom: 6),
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(56, 86, 244, 0.4), // 阴影的颜色
                    offset: Offset(0, 6), // 阴影与容器的距离
                    blurRadius: 10, // 高斯的标准偏差与盒子的形状卷积。
                    spreadRadius: 0, // 在应用模糊之前，框应该膨胀的量。
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(60)),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(107, 101, 244, 1),
                      Color.fromRGBO(51, 84, 244, 1)
                    ])),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/add_project');
              },
              child: const Icon(
                Icons.add,
                color: Color.fromRGBO(240, 242, 243, 1),
                size: 36,
              ),
            )));
  }

  // 获取计划
  List<Widget> _getProject() {
    List<Widget> list = [];
    var l = projectData['project'] as List<dynamic>;
    list = l.map((e) {
      return _projectCard(Project.fromMap(e));
    }).toList();
    list.add(projectAddButton());
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabExteriorController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    _tabInteriorController =
        TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'infoPage',
        title: '计划',
      ),
      body: Column(
        children: <Widget>[
          // ElevatedButton(
          //     onPressed: () {
          //       // var maplist = jsonDecode(data.toString());
          //       var json = data['data'] as Map;
          //       // print(Article.fromMap(json));
          //       print(Article.fromMap(json['news'][0]));
          //     },
          //     child: Text('click'))
          SizedBox(
            height: 60,
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
                  _customTab(
                      '计划列表', _tabExteriorController.index == 0 ? 1 : 0.5),
                  _customTab(
                      '互助小组', _tabExteriorController.index == 1 ? 1 : 0.5),
                ]),
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
                        indicator:
                            const BoxDecoration(color: Colors.transparent),
                        indicatorWeight: 0,
                        labelPadding: const EdgeInsets.only(left: 6, right: 6),
                        controller: _tabInteriorController,
                        tabs: [
                          _customTab('进行中',
                              _tabInteriorController.index == 0 ? 1 : 0.5,
                              isMini: true),
                          _customTab('已完成',
                              _tabInteriorController.index == 1 ? 1 : 0.5,
                              isMini: true),
                          _customTab(
                              '全部', _tabInteriorController.index == 2 ? 1 : 0.5,
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
                            children: _getProject(),
                          ),
                          const Text('2'),
                          const Text('2')
                        ]))
                  ],
                ),
                const Text('2')
              ])),
        ],
      ),
    );
  }
}
