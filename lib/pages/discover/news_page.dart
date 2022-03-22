import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_track/config/http_config.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/article_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  String category;
  NewsPage(this.category, {Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // 滚动控制器
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
  double pos = 0;

  final EasyRefreshController _controller = EasyRefreshController();

  List datalist = [];
  int listIndex = 0;
  @override
  void initState() {
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
    _getList();
  }

  Future _getList({bool refersh = false}) async {
    var data;
    if (widget.category == '推荐') {
      data = {"start": listIndex};
    } else {
      data = {"start": listIndex, "hashtag": widget.category};
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Options options = Options(headers: {
      'authorization': prefs.getString('token'),
      'content-type': 'application/json'
    });

    DioUtil().post('/news/newslist', data: data, success: (success) {
      List res = success['data'];
      // print(res);
      print('当前请求长度为$listIndex，获取数据长度为${res.length}');
      listIndex += res.length;

      setState(() {
        if (refersh) {
          datalist = res;
        } else {
          datalist.addAll(res);
        }
      });
    }, error: (error) {});
  }

  // 下拉刷新
  Future _onRefresh() async {
    listIndex = 0;
    _getList(refersh: true);
  }

  // 上拉加载
  Future _onLoad() async {
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      onLoad: _onLoad,
      onRefresh: _onRefresh,
      header: ClassicalHeader(
          refreshText: '下拉刷新',
          refreshReadyText: '松开手刷新',
          refreshedText: '刷新成功',
          refreshingText: '刷新中',
          refreshFailedText: '刷新失败'),
      footer: ClassicalFooter(
          loadText: '上拉加载',
          loadReadyText: '松开手加载',
          loadedText: '加载成功',
          loadingText: '加载中',
          loadFailedText: '加载失败'),
      child: ListView.builder(
        itemCount: datalist.length,
        itemBuilder: (context, index) {
          return ArticleCard(Article.fromMap(datalist[index]));
        },
        padding: const EdgeInsets.only(top: 17),
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }
}

// 传递Nav导航栏显示状态
class NavNotification extends Notification {
  bool isNavShow;
  NavNotification(this.isNavShow);
}
