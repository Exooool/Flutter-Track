import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/discover/article_comment.dart';
import 'package:get/get.dart';
import 'package:zefyrka/zefyrka.dart';

class ArticlePage extends StatefulWidget {
  ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with TickerProviderStateMixin {
  late ZefyrController _controller = ZefyrController();
  late Article news;

  // 动画参数
  late AnimationController controller;
  late Animation<Offset> animation1;
  late Animation<Offset> animation2;
  late Animation<Offset> animation3;
  late Animation<double> opacityAnimation;
  late CurvedAnimation curve;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    curve = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation1 = Tween(begin: Offset(15.r, 60.r), end: Offset(15.r, 180.r))
        .animate(curve);

    animation2 = Tween(begin: Offset(15.r, 60.r), end: Offset(110.r, 146.r))
        .animate(curve);

    animation3 = Tween(begin: Offset(15.r, 60.r), end: Offset(150.r, 60.r))
        .animate(curve);

    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0, 1 / 8)));
    _getNew();
  }

  _getNew() {
    news = Get.arguments['news'];
    _controller =
        ZefyrController(NotusDocument.fromJson(jsonDecode(news.newsContent)));
  }

  // Future _getNew() async {
  //   // 获取传递过来的参数
  //   final arguments = Get.arguments;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Options options = Options(headers: {
  //     'authorization': prefs.getString('token'),
  //     'content-type': 'application/json'
  //   });

  //   var response = await Dio().post(HttpOptions.BASE_URL + '/news/getNew',
  //       data: arguments, options: options);
  //   List res = response.data['data'];

  //   newsContetnt = jsonDecode(res[0]['news_content']);
  //   // print(newsContetnt);
  //   // print(res[0]['news_content']);
  //   _controller = ZefyrController(NotusDocument.fromJson(newsContetnt));
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        '',
        leading: InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
        ending: InkWell(
          onTap: () {},
          child: Image.asset(
            'lib/assets/icons/Out.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 文章主要内容
          ListView(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 7.h),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // 作者栏
                  InkWell(
                    onTap: () {
                      print('点击');
                    },
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            news.userImg,
                            height: 66.r,
                            width: 66.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(news.userName)
                      ],
                    ),
                  ),
                  PublicCard(
                      radius: 90.r,
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 6.h, bottom: 6.h),
                      notWhite: true,
                      widget: Center(
                        child: Text(
                          '关注',
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              color: MyColor.fontWhite),
                        ),
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                child: Text(
                  news.newsTitle,
                  style: TextStyle(fontSize: MyFontSize.font22),
                ),
              ),
              Row(children: [
                Image.asset(
                  'lib/assets/icons/View_fill.png',
                  height: 18.r,
                  width: 18.r,
                ),
                SizedBox(width: 3.w),
                Text(
                  news.viewNum.toString(),
                  style: TextStyle(fontSize: MyFontSize.font10),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 18.w, right: 12.w),
                    child: Row(
                      children: [
                        Image.asset(
                          'lib/assets/icons/Chat_fill.png',
                          height: 18.r,
                          width: 18.r,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          news.commentNum.toString(),
                          style: TextStyle(fontSize: MyFontSize.font10),
                        ),
                      ],
                    )),
                Image.asset(
                  'lib/assets/icons/Favorite_fill.png',
                  height: 18.r,
                  width: 18.r,
                ),
                SizedBox(width: 3.w),
                Text(
                  news.likeNum.toString(),
                  style: TextStyle(fontSize: MyFontSize.font10),
                ),
              ]),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  formatDate(
                      DateTime.parse(news.newsTime), [yyyy, '.', mm, '.', dd]),
                  style: TextStyle(fontSize: MyFontSize.font10),
                ),
              ),
              ZefyrEditor(
                focusNode: FocusNode(canRequestFocus: false),
                readOnly: true,
                padding: EdgeInsets.only(top: 7.h),
                controller: _controller,
                embedBuilder: customZefyrEmbedBuilder,
              ),
            ],
          ),

          // 弹出
          Positioned(
              right: animation1.value.dx,
              bottom: animation1.value.dy,
              child: Opacity(
                opacity: opacityAnimation.value,
                child: PublicCard(
                  radius: 90.r,
                  height: 72.r,
                  width: 72.r,
                  widget: Center(
                      child: Image.asset(
                    'lib/assets/icons/Favorite_fill.png',
                    height: 44.r,
                    width: 44.r,
                  )),
                ),
              )),
          Positioned(
              right: animation2.value.dx,
              bottom: animation2.value.dy,
              child: Opacity(
                opacity: opacityAnimation.value,
                child: PublicCard(
                  radius: 90.r,
                  height: 72.r,
                  width: 72.r,
                  onTap: () => Get.to(() => ArticleComment(), arguments: {
                    'user_id': news.userId,
                    'news_id': news.newsId
                  }),
                  widget: Center(
                      child: Image.asset(
                    'lib/assets/icons/Chat_fill.png',
                    height: 44.r,
                    width: 44.r,
                  )),
                ),
              )),

          Positioned(
              right: animation3.value.dx,
              bottom: animation3.value.dy,
              child: Opacity(
                opacity: opacityAnimation.value,
                child: PublicCard(
                  radius: 90.r,
                  height: 72.r,
                  width: 72.r,
                  widget: Center(
                      child: Image.asset(
                    'lib/assets/icons/Star.png',
                    height: 44.r,
                    width: 44.r,
                  )),
                ),
              )),

          // 评论、点赞等功能那个
          Positioned(
            right: 15.r,
            bottom: 60.r,
            child: PublicCard(
                radius: 90.r,
                height: 72.r,
                width: 72.r,
                onTap: () {
                  if (controller.status == AnimationStatus.completed) {
                    controller.reverse();
                  } else if (controller.status == AnimationStatus.dismissed) {
                    controller.forward();
                  }
                },
                widget: Center(
                  child: Image.asset(
                    'lib/assets/icons/More.png',
                    height: 44.r,
                    width: 44.r,
                  ),
                )),
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
