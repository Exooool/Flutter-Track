import 'package:flutter/material.dart';
// 样式导入
import 'package:flutter_track/common/style/my_style.dart';

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
          height: 36,
          width: inner ? 75 : 108,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gradient: MyWidgetStyle.mainLinearGradient),
          child: nums == null
              ? Text(
                  title,
                  style: const TextStyle(
                      height: 1,
                      color: MyColor.fontWhite,
                      fontSize: MyFontSize.font14),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            height: 1,
                            color: MyColor.fontWhite,
                            fontSize: MyFontSize.font16)),
                    Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      decoration: const BoxDecoration(
                          color: MyColor.fontWhiteO5,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: 1,
                      height: 14,
                    ),
                    Text(nums,
                        style: const TextStyle(
                            height: 1,
                            color: MyColor.fontWhite,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: <Widget>[
          SizedBox(
            child: TabBar(
                isScrollable: true,
                onTap: (e) {
                  setState(() {});
                },
                labelPadding: const EdgeInsets.only(left: 6, right: 6),
                controller: _tabExteriorController,
                indicator: const BoxDecoration(color: Colors.transparent),
                indicatorWeight: 0,
                tabs: parseTabs(widget.exteriorTabs, true)),
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
