import 'package:flutter/material.dart';
import './discover/news.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // 去除阴影
            elevation: 0,
            // leading为左侧actions功能
            leading: SizedBox(
              width: 60,
              child: InkWell(
                onTap: () {},
                child: const Center(
                  child: Text('搜索'),
                ),
              ),
            ),
            // leading为左侧actions功能
            actions: [
              SizedBox(
                width: 60,
                child: InkWell(
                  onTap: () {},
                  child: const Center(
                    child: Text('发布'),
                  ),
                ),
              )
            ],
            title: const TabBar(tabs: <Widget>[
              Tab(
                text: '资讯',
              ),
              Tab(
                text: '动态',
              )
            ]),
            centerTitle: true,
          ),
          body: TabBarView(children: <Widget>[
            NewsComponent(),
            Center(
              child: const Text('2'),
            ),
          ]),
        ));
  }
}
