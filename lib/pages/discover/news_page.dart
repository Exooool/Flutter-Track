import 'dart:ffi';

import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  List<Widget> list;
  String category;
  NewsPage(this.list, this.category, {Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // 滚动控制器
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
  double pos = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      // 更新状态
      setState(() {
        var currentPos = scrollController.offset;
        if (scrollController.offset - pos > 0) {
          // print('下滑');
          NavNotification(false).dispatch(context);
        } else if (scrollController.offset - pos < 0) {
          // print('上滑');
          NavNotification(true).dispatch(context);
        }
        pos = currentPos;
      });
      // print("监听滚动的位置 ${scrollController.offset}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(controller: scrollController, children: widget.list);
  }
}

class NavNotification extends Notification {
  bool isNavShow;
  NavNotification(this.isNavShow);
}
