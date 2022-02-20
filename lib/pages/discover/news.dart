import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import './news_page.dart';
import './news_card.dart';

import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/assets/test.dart';

class NewsComponent extends StatefulWidget {
  NewsComponent({Key? key}) : super(key: key);

  @override
  _NewsComponentState createState() => _NewsComponentState();
}

class _NewsComponentState extends State<NewsComponent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 自定义tab样式
  Widget _customTab(String content) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.5, bottom: 5.5, left: 14, right: 14),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  final _tabList = const [
    '关注',
    '推荐',
    '生活',
    '心理',
    '运动',
    '语言',
    '升学',
    '校园',
    '读书',
    '哲学'
  ];

  List dataList = [];

  // 获取资讯列表
  List<Widget> _getNewsArticle() {
    List<Widget> list = [];
    var json = data['data'] as Map;
    var l = json['news'] as List<dynamic>;
    list = l.map((e) {
      return NewsCard(Article.fromMap(e));
    }).toList();
    return list;
  }

  //
  List<Widget> _tabContent() {
    List<Widget> list = _tabList.map((e) {
      return NewsPage(_getNewsArticle(), e);
    }).toList();
    return list;
  }

  // 标签分类排序
  showSortTabItem() {
    // 底部弹窗
    // 对tab栏进行排序
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 500,
          width: 500,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(234, 236, 239, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                '长按拖动排序',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(0, 0, 0, 0.5)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(length: _tabList.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 销毁tabController
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // 让此Scaffold的appbar的高度为零
        toolbarHeight: 0,
        bottom: PreferredSize(
          // 设置高度
          preferredSize: const Size.fromHeight(90),
          child: Column(
            children: <Widget>[
              // tabbar栏
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 10, right: 46),
                      child: TabBar(
                        physics: const BouncingScrollPhysics(),
                        // padding: const EdgeInsets.all(0),
                        labelColor: const Color.fromRGBO(240, 242, 243, 1),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle:
                            const TextStyle(fontWeight: FontWeight.normal),
                        unselectedLabelColor: const Color.fromRGBO(0, 0, 0, 1),
                        // 更改指示点样式
                        indicator: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(107, 101, 244, 1),
                                  Color.fromRGBO(51, 84, 244, 1)
                                ])),
                        // indicatorSize: TabBarIndicatorSize.label,

                        labelPadding: const EdgeInsets.all(0),
                        isScrollable: true,
                        tabs: _tabList.map((e) {
                          return _customTab(e);
                        }).toList(),
                        controller: _tabController,
                      )),
                  // 菜单按钮
                  Positioned(
                    right: 26,
                    child: InkWell(
                        onTap: () {
                          showSortTabItem();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: const Icon(Icons.menu),
                        )),
                  )
                ],
              ),
              // 搜索框
              Container(
                height: 24,
                margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    borderRadius: BorderRadius.all(Radius.circular(60))),
                // 不进行搜索功能 点击后跳转到搜索页
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.search),
                    Expanded(
                        child: TextField(
                      onTap: () {
                        print('跳转搜索页');
                      },
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration.collapsed(
                        // isDense: true,
                        enabled: true,
                        hintText: '关于如何提高自己的管理能力',

                        hintStyle: TextStyle(fontSize: 12),
                      ),
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabContent(),
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
