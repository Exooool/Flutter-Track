import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/public_card.dart';

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
  const ArticleCard(this.news, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Center(
          child: PublicCard(
            radius: 10.r,
            height: 223.h,
            width: 366.w,
            widget: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // 标题行
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        news.title,
                        style: TextStyle(
                            fontSize: MyFontSize.font18,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      InkWell(
                        onTap: () {},
                        child: const Icon(Icons.menu),
                      )
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ClipOval(
                                  child: Image.network(
                                    news.author.userImg,
                                    height: 24.h,
                                    width: 24.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  news.author.userName,
                                  style: TextStyle(
                                      fontSize: MyFontSize.font12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  news.postTime,
                                  style: TextStyle(
                                      fontSize: MyFontSize.font12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            Text(
                              news.content,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: MyFontSize.font12),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Image.network(
                        news.contentImg,
                        width: 158.w,
                        height: 110.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('未找到图片');
                        },
                      )
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        news.tag,
                        style: TextStyle(fontSize: MyFontSize.font10),
                      ),
                      Row(children: [
                        Text(
                          '观看数',
                          style: TextStyle(fontSize: MyFontSize.font9),
                        ),
                        Text(
                          '评论数',
                          style: TextStyle(fontSize: MyFontSize.font9),
                        ),
                        Text(
                          '点赞数',
                          style: TextStyle(fontSize: MyFontSize.font9),
                        ),
                      ])
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
