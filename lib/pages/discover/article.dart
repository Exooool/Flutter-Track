import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/config/http_config.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zefyrka/zefyrka.dart';

class ArticlePage extends StatefulWidget {
  ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late List newsContetnt;
  late ZefyrController _controller = ZefyrController();

  @override
  void initState() {
    super.initState();
    _getNew();
  }

  Future _getNew() async {
    // 获取传递过来的参数
    final arguments = Get.arguments;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Options options = Options(headers: {
      'authorization': prefs.getString('token'),
      'content-type': 'application/json'
    });

    var response = await Dio().post(HttpOptions.BASE_URL + '/news/getNew',
        data: arguments, options: options);
    List res = response.data['data'];

    newsContetnt = jsonDecode(res[0]['news_content']);
    // print(newsContetnt);
    // print(res[0]['news_content']);
    _controller = ZefyrController(NotusDocument.fromJson(newsContetnt));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(''),
      body: ListView(
        children: <Widget>[
          Row(),
          ZefyrEditor(
            // focusNode: null,
            // readOnly: true,
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 7.h),
            controller: _controller,
            embedBuilder: customZefyrEmbedBuilder,
          ),
        ],
      ),
    );
  }
}

Widget customZefyrEmbedBuilder(BuildContext context, EmbedNode node) {
  if (node.value.type.contains('http://') ||
      node.value.type.contains('https://')) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              child: Image.network(
                node.value.type,
                fit: BoxFit.fill,
              ),
            ),
            // Text(node.value.type)
          ],
        ),
      ),
    );
  }

  return Container();
}
