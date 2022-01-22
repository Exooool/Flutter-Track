import 'package:flutter/material.dart';

class NewsComponent extends StatefulWidget {
  NewsComponent({Key? key}) : super(key: key);

  @override
  _NewsComponentState createState() => _NewsComponentState();
}

class _NewsComponentState extends State<NewsComponent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabList = const [
    Tab(text: '关注'),
    Tab(text: '推荐'),
    Tab(text: '生活'),
    Tab(text: '心理'),
    Tab(text: '运动'),
    Tab(text: '语言'),
    Tab(text: '升学'),
    Tab(text: '校园'),
    Tab(text: '读书'),
    Tab(text: '哲学'),
  ];

  final List<Widget> _tabContent = const [
    Text('1'),
    Text('2'),
    Text('3'),
    Text('4'),
    Text('5'),
    Text('6'),
    Text('7'),
    Text('8'),
    Text('9'),
    Text('10'),
  ];

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
        backgroundColor: Colors.white,
        elevation: 0,
        // 让此Scaffold的appbar的高度为零
        toolbarHeight: 0,
        bottom: TabBar(
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: _tabList,
          controller: _tabController,
        ),
      ),
      body: TabBarView(controller: _tabController, children: _tabContent),
    );
  }
}
