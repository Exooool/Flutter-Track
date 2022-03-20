import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/discover/article.dart';
import 'package:get/get.dart';

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
  final bool small;
  const ArticleCard(this.news, {Key? key, this.small = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Center(
          child: PublicCard(
            radius: 10.r,
            height: 223.h,
            width: 366.w,
            onTap: () => Get.to(() => ArticlePage(),
                arguments: {'news_id': news.newsId}),
            widget: Padding(
              padding: EdgeInsets.all(12.r),
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
                            fontSize: MyFontSize.font18,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                  // SizedBox(height: 8.h),
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
                                  child: Image.network(
                                    news.userImg,
                                    height: 24.h,
                                    width: 24.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  news.userName,
                                  style: TextStyle(
                                      fontSize: MyFontSize.font12,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  news.newsTime.substring(0, 10),
                                  style: TextStyle(
                                      height: 1.6,
                                      fontSize: MyFontSize.font12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              news.newsContent,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: MyFontSize.font12),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      ClipRRect(
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
                      )
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 50.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          news.hashtag,
                          style: TextStyle(fontSize: MyFontSize.font10),
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
                                    style:
                                        TextStyle(fontSize: MyFontSize.font10),
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
