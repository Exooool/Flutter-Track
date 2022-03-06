import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';

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
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Container(
            // padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                gradient: MyWidgetStyle.secondLinearGradient),
            height: 190,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 0.1, sigmaY: 0.1, tileMode: TileMode.decal),
              child: CustomPaint(
                painter: BorderGradientPainter(
                    radius: 10,
                    strokeWidth: 2,
                    gradient: MyWidgetStyle.borderLinearGradient),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      // 标题行
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            news.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          InkWell(
                            onTap: () {},
                            child: const Icon(Icons.menu),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ClipOval(
                                      child: Image.network(
                                        news.author.userImg,
                                        height: 24,
                                        width: 24,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      news.author.userName,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      news.postTime,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                Text(
                                  news.content,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Image.network(
                            news.contentImg,
                            width: 158,
                            height: 110,
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
                            style: TextStyle(fontSize: 10),
                          ),
                          Row(children: const [
                            Text(
                              '观看数',
                              style: TextStyle(fontSize: 9),
                            ),
                            Text(
                              '评论数',
                              style: TextStyle(fontSize: 9),
                            ),
                            Text(
                              '点赞数',
                              style: TextStyle(fontSize: 9),
                            ),
                          ])
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
