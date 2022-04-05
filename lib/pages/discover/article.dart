import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';

import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/discover/article_comment.dart';
import 'package:flutter_track/pages/user/user_model.dart';
import 'package:flutter_track/service/service.dart';
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
  Map news = {};
  int nowUserId = 00;
  late int newsId;

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
    newsId = Get.arguments['news_id'];

    // 查询文章信息
    DioUtil().post('/news/view', data: {'news_id': newsId}, success: (res) {
      print(res['data'][0]);

      if (mounted) {
        setState(() {
          news = res['data'][0];
          _controller = ZefyrController(
              NotusDocument.fromJson(jsonDecode(news['news_content'])));
        });
      }
    }, error: (error) {
      print(error);
    });

    // 获取当前用户id
    DioUtil().get('/users/id', success: (res) {
      print(res);

      if (mounted) {
        setState(() {
          nowUserId = res['user_id'];
        });
      }
    }, error: (error) {
      print(error);
    });
  }

  // 收藏
  _star() {
    DioUtil().post('/news/star', data: {'news_id': newsId}, success: (res) {
      print(res);

      if (res['status'] == 0) {
        Get.snackbar('提示', '收藏成功');
      } else {
        Get.snackbar('提示', '取消收藏');
      }
    }, error: (error) {
      print(error);
    });
  }

  // 点赞
  _like() {
    DioUtil().post('/news/like', data: {'news_id': newsId}, success: (res) {
      print(res);

      if (res['status'] == 0) {
        Get.snackbar('提示', '点赞成功');
      } else {
        Get.snackbar('提示', '你已经点赞');
      }
    }, error: (error) {
      print(error);
    });
  }

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
      body: news['news_id'] == null
          ? Container()
          : Stack(
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
                            if (news['user_id'] != nowUserId) {
                              Get.to(() => UserModelPage(), arguments: {
                                'query_user_id': news['user_id']
                              });
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                child: news['user_img'] == ''
                                    ? Image.asset(
                                        'lib/assets/images/defaultUserImg.png',
                                        height: 66.r,
                                        width: 66.r,
                                      )
                                    : Image.network(
                                        news['user_img'],
                                        height: 66.r,
                                        width: 66.r,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                news['user_name'],
                                style: TextStyle(
                                    fontSize: MyFontSize.font19,
                                    fontFamily: MyFontFamily.pingfangMedium),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: news['user_id'] == nowUserId ? false : true,
                          child: PublicCard(
                              radius: 90.r,
                              padding: EdgeInsets.only(
                                  left: 20.w,
                                  right: 20.w,
                                  top: 6.h,
                                  bottom: 6.h),
                              notWhite: true,
                              widget: Center(
                                child: Text(
                                  '关注',
                                  style: TextStyle(
                                      fontFamily: MyFontFamily.pingfangSemibold,
                                      fontSize: MyFontSize.font16,
                                      color: MyColor.fontWhite),
                                ),
                              )),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                      child: Text(
                        news['news_title'],
                        style: TextStyle(
                            fontSize: MyFontSize.font22,
                            fontFamily: MyFontFamily.pingfangMedium),
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
                        news['view_num'].toString(),
                        style: TextStyle(
                            fontSize: MyFontSize.font10,
                            fontFamily: MyFontFamily.sfDisplayRegular),
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
                                news['comment_num'].toString(),
                                style: TextStyle(
                                    fontSize: MyFontSize.font10,
                                    fontFamily: MyFontFamily.sfDisplayRegular),
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
                        '${jsonDecode(news['like_num']).length}',
                        style: TextStyle(
                            fontSize: MyFontSize.font10,
                            fontFamily: MyFontFamily.sfDisplayRegular),
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(
                        formatDate(DateTime.parse(news['news_time']),
                            [yyyy, '.', mm, '.', dd]),
                        style: TextStyle(
                            fontSize: MyFontSize.font10,
                            fontFamily: MyFontFamily.sfDisplayRegular),
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
                        onTap: _like,
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
                          'user_id': news['user_id'],
                          'news_id': news['news_id']
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
                        onTap: _star,
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
                        } else if (controller.status ==
                            AnimationStatus.dismissed) {
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
