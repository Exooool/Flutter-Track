import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 样式导入
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/article_card.dart';
import 'package:flutter_track/pages/components/union_widget.dart';

import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/project_card.dart';
import 'package:get/get.dart';

class TwoLayerTab extends StatefulWidget {
  final List exteriorTabs;
  final List interiorTabs;
  final List exteriorViews;
  final List interiorViews;
  const TwoLayerTab({
    Key? key,
    required this.exteriorTabs,
    required this.interiorTabs,
    required this.exteriorViews,
    required this.interiorViews,
  }) : super(key: key);

  @override
  State<TwoLayerTab> createState() => _TwoLayerTabState();
}

class _TwoLayerTabState extends State<TwoLayerTab>
    with TickerProviderStateMixin {
  // 外层tab的controller
  late TabController _tabExteriorController;
  // 内层tab的controller
  late TabController _tabInteriorController;

  // tab按钮
  Widget customTab(String title, double opcity, bool inner, {String? nums}) {
    return Opacity(
      opacity: 0.8,
      child: Container(
        height: 36.h,
        width: 75.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            gradient: MyWidgetStyle.mainLinearGradient),
        child: Text(title, style: TextStyle(fontSize: MyFontSize.font14)),
      ),
    );
  }

  List<Widget> parseTabs(List list, bool isEx) {
    List<Widget> result = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i]['nums'] == null) {
        result.add(customTab(list[i]['title'],
            _tabInteriorController.index == i ? 1 : 0.5, true));
      } else {
        result.add(customTab(
            list[i]['title'], _tabInteriorController.index == i ? 1 : 0.5, true,
            nums: list[i]['nums']));
      }
    }
    return result;
  }

  // 获取资讯列表
  List<Widget> _getNewsArticle(List articleList) {
    List<Widget> list = [];

    list = articleList.map((e) {
      return ArticleCard(Article.fromMap(e), type: 1);
    }).toList();
    return list;
  }

  // 获取计划
  List<Widget> _getProject(List projectList) {
    List<Widget> list = [];
    list = projectList.map((e) {
      return ProjectCard(Project.fromMap(e));
    }).toList();
    return list;
  }

  @override
  void initState() {
    super.initState();
    _tabExteriorController = TabController(
        length: widget.exteriorTabs.length, vsync: this, initialIndex: 0);
    _tabInteriorController = TabController(
        length: widget.interiorTabs.length, vsync: this, initialIndex: 0);
  }

  Widget mainTab(String title, int index) {
    return InkWell(
      onTap: () {
        _tabExteriorController.index = index;
        print(_tabExteriorController.index);
        setState(() {});
      },
      child: Container(
        height: 36.h,
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        alignment: Alignment.center,
        decoration: _tabExteriorController.index == index
            ? null
            : BoxDecoration(
                gradient: MyWidgetStyle.secondLinearGradient,
                borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: Text(title,
            style: TextStyle(
                fontSize: MyFontSize.font16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // 格式化
  String formatNum(int num) {
    if (num < 10) {
      return '0$num';
    } else if (num > 99) {
      return '99+';
    } else {
      return num.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取个数
    final targetNum = widget.interiorViews[0].length;
    final collectNum = widget.exteriorViews[0].length;
    final newsNum = widget.exteriorViews[1].length;
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: UnionTabView(
        height: double.maxFinite,
        title: const ['---', '----', '---'],
        index: _tabExteriorController.index,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              mainTab('目标' + formatNum(targetNum), 0),
              mainTab('收藏' + formatNum(collectNum), 1),
              mainTab('发布' + formatNum(newsNum), 2),
            ],
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: 12.h),
            child: TabBarView(
                // 禁止滑动
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabExteriorController,
                children: <Widget>[
                  widget.interiorTabs.isEmpty
                      ? ListView(
                          padding: EdgeInsets.only(
                              top: 12.h,
                              left: 12.w,
                              right: 12.w,
                              bottom: 100.h),
                          children: _getProject(widget.interiorViews[0]),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 12.h),
                              child: TabBar(
                                  isScrollable: true,
                                  onTap: (e) {
                                    setState(() {});
                                  },
                                  indicator: const BoxDecoration(
                                      color: Colors.transparent),
                                  indicatorWeight: 0,
                                  labelPadding:
                                      EdgeInsets.only(left: 6.w, right: 6.w),
                                  controller: _tabInteriorController,
                                  tabs: parseTabs(widget.interiorTabs, false)),
                            ),
                            Expanded(
                                child: TabBarView(
                                    // 禁止滑动
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: _tabInteriorController,
                                    children: <Widget>[
                                  ListView(
                                    padding: EdgeInsets.only(
                                        top: 12.h,
                                        left: 12.w,
                                        right: 12.w,
                                        bottom: 100.h),
                                    children:
                                        _getProject(widget.interiorViews[0]),
                                  ),
                                  ListView(
                                    padding: EdgeInsets.only(
                                        top: 12.h,
                                        left: 12.w,
                                        right: 12.w,
                                        bottom: 100.h),
                                    children:
                                        _getProject(widget.interiorViews[0]),
                                  ),
                                ]))
                          ],
                        ),
                  ListView(
                    padding: EdgeInsets.only(
                        top: 12.h, left: 12.w, right: 12.w, bottom: 100.h),
                    children: _getNewsArticle(widget.exteriorViews[0]),
                  ),
                  ListView(
                    padding: EdgeInsets.only(
                        top: 12.h, left: 12.w, right: 12.w, bottom: 100.h),
                    children: _getNewsArticle(widget.exteriorViews[1]),
                  ),
                ]),
          ))
        ],
      ),
    );
  }
}
