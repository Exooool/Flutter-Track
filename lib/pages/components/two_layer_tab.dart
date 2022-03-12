import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 样式导入
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/union_widget.dart';

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
        opacity: opcity,
        child: Container(
          alignment: Alignment.center,
          height: 36.h,
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
          child: nums == null
              ? Text(
                  title,
                  style: TextStyle(
                      height: 1,
                      color: MyColor.fontWhite,
                      fontSize: MyFontSize.font14),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title,
                        style: TextStyle(
                            height: 1,
                            color: MyColor.fontBlack,
                            fontSize: MyFontSize.font16)),
                    Text(nums,
                        style: TextStyle(
                            height: 1,
                            color: MyColor.fontBlack,
                            fontSize: MyFontSize.font18))
                  ],
                ),
        ));
  }

  List<Widget> parseTabs(List list, bool isEx) {
    List<Widget> result = [];
    if (isEx) {
      for (var i = 0; i < list.length; i++) {
        if (list[i]['nums'] == null) {
          result.add(customTab(list[i]['title'],
              _tabExteriorController.index == i ? 1 : 0.5, false));
        } else {
          result.add(customTab(list[i]['title'],
              _tabExteriorController.index == i ? 1 : 0.5, false,
              nums: list[i]['nums']));
        }
      }
    } else {
      for (var i = 0; i < list.length; i++) {
        if (list[i]['nums'] == null) {
          result.add(customTab(list[i]['title'],
              _tabInteriorController.index == i ? 1 : 0.5, true));
        } else {
          result.add(customTab(list[i]['title'],
              _tabInteriorController.index == i ? 1 : 0.5, true,
              nums: list[i]['nums']));
        }
      }
    }

    return result;
  }

  List<Widget> getList(List list) {
    List<Widget> result;
    result = list.map((item) {
      return Text(item['title']);
    }).toList();
    return result;
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
        width: 112.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: MyWidgetStyle.secondLinearGradient,
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: UnionTabView(
        height: 400.h,
        title: ['目标08s', '', ''],
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TabBar(
              //     isScrollable: true,
              //     onTap: (e) {
              //       setState(() {});
              //     },
              //     padding: const EdgeInsets.all(0),
              //     labelPadding: const EdgeInsets.all(0),
              //     controller: _tabExteriorController,
              //     indicator: const BoxDecoration(color: Colors.transparent),
              //     indicatorWeight: 0,
              //     tabs: parseTabs(widget.exteriorTabs, true)),
              mainTab('目标08', 0),
              mainTab('目标08', 1),
              mainTab('目标08', 2),
            ],
          ),
          Expanded(
              child: TabBarView(
                  // 禁止滑动
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabExteriorController,
                  children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: TabBar(
                          isScrollable: true,
                          onTap: (e) {
                            setState(() {});
                          },
                          indicator:
                              const BoxDecoration(color: Colors.transparent),
                          indicatorWeight: 0,
                          labelPadding:
                              const EdgeInsets.only(left: 6, right: 6),
                          controller: _tabInteriorController,
                          tabs: parseTabs(widget.interiorTabs, false)),
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
                            children: getList(widget.interiorViews[0]),
                          ),
                          ListView(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, bottom: 100),
                            children: getList(widget.interiorViews[0]),
                          )
                        ]))
                  ],
                ),
                ListView(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 100),
                  children: getList(widget.exteriorViews[0]),
                ),
                ListView(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 100),
                  children: getList(widget.exteriorViews[1]),
                ),
              ]))
        ],
      ),
    );
  }
}
