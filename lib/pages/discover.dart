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
            // elevation: 0,
            // 设置appbar底部左右圆角边框
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            // 弹性空间 设置appbar背景渐变色
            flexibleSpace: Container(
              // 设置内部container的圆角
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  // 设置线性渐变
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(107, 101, 244, 1),
                        Color.fromRGBO(51, 84, 244, 1)
                      ])),
            ),
            title: const SizedBox(
              child: TabBar(
                  // 隐藏指示点
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(left: 9, right: 9),
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  labelColor: Color.fromRGBO(240, 242, 243, 1),
                  unselectedLabelColor: Color.fromRGBO(240, 242, 243, 0.5),
                  unselectedLabelStyle: TextStyle(fontSize: 15),
                  padding: EdgeInsets.all(0),
                  indicator: BoxDecoration(color: Colors.transparent),
                  tabs: <Widget>[
                    Tab(
                      text: '资讯',
                    ),
                    Tab(
                      text: '动态',
                    )
                  ]),
            ),
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
