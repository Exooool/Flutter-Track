import 'dart:convert';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/discover/article.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BorderGradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  BorderGradientPainter(
      {required this.radius,
      required this.strokeWidth,
      required this.gradient});
  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ArticleCard extends StatelessWidget {
  final Article news;
  final int type;
  const ArticleCard(this.news, {Key? key, this.type = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Center(
          child: PublicCard(
            radius: 10.r,
            width: 366.w,
            type: type,
            // 传递news对象给文章页面
            onTap: () async {
              List list = [];
              bool flag = false;
              SharedPreferences prefs = await SharedPreferences.getInstance();

              Map historyString = {
                'news_id': news.newsId,
                'news_img': news.newsImg,
                'user_name': news.userName,
                'news_title': news.newsTitle
              };
              if (prefs.getString('history') != null) {
                list = jsonDecode(prefs.getString('history')!);
              }
              for (var i = 0; i < list.length; i++) {
                if (list[i]['news_id'] == news.newsId) {
                  list.add(list.removeAt(i));
                  flag = true;
                  break;
                }
              }

              if (!flag) {
                list.add(historyString);
              }

              prefs.setString('history', jsonEncode(list));

              Get.to(() => ArticlePage(), arguments: {'news_id': news.newsId});
            },
            widget: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // 标题行
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        news.newsTitle,
                        style: TextStyle(
                            fontSize: MyFontSize.font19,
                            fontFamily: MyFontFamily.pingfangMedium),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ClipOval(
                                  child: news.userImg == ''
                                      ? Image.asset(
                                          'lib/assets/images/defaultUserImg.png',
                                          height: 24.r,
                                          width: 24.r,
                                        )
                                      : Image.network(
                                          news.userImg,
                                          height: 24.r,
                                          width: 24.r,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  news.userName,
                                  style: TextStyle(
                                      fontSize: MyFontSize.font12,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: MyFontFamily.pingfangMedium),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                    child: Text(
                                  formatDate(DateTime.parse(news.newsTime),
                                      [yyyy, '.', mm, '.', dd]),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: MyFontSize.font12,
                                      fontFamily: MyFontFamily.pingfangRegular),
                                ))
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Visibility(
                                visible: news.content != '',
                                child: Text(
                                  news.content,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: MyFontSize.font12,
                                      fontFamily: MyFontFamily.pingfangRegular),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Visibility(
                        visible: news.content != '',
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          child: Image.network(
                            news.newsImg,
                            width: 158.w,
                            height: 110.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/assets/images/404.jpg',
                                width: 158.w,
                                height: 110.h,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),

                  Visibility(
                    visible: news.content == '',
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      child: Image.network(
                        news.newsImg,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'lib/assets/images/404.jpg',
                            width: 158.w,
                            height: 110.h,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.only(right: 49.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          news.hashtag,
                          style: TextStyle(
                              fontSize: MyFontSize.font10,
                              fontFamily: MyFontFamily.pingfangMedium,
                              color: MyColor.fontBlackO2),
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
                            style: TextStyle(
                                fontSize: MyFontSize.font10,
                                fontFamily: MyFontFamily.pingfangRegular),
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
                                    style: TextStyle(
                                        fontSize: MyFontSize.font10,
                                        fontFamily:
                                            MyFontFamily.pingfangRegular),
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
                            '${news.likeNum.toList().length}',
                            style: TextStyle(
                                fontSize: MyFontSize.font10,
                                fontFamily: MyFontFamily.pingfangRegular),
                          ),
                        ])
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
