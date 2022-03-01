import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_track/model/news_model.dart';

// 资讯卡片
class NewsCard extends StatefulWidget {
  Article news;
  NewsCard(this.news, {Key? key}) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Neumorphic(
            style: NeumorphicStyle(
                shadowLightColor: const Color.fromRGBO(255, 255, 255, 1),
                shadowDarkColor: const Color.fromRGBO(174, 174, 192, 0.5),
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 6,
                color: const Color.fromRGBO(240, 240, 243, 1)),
            child: Container(
              padding: const EdgeInsets.all(12),
              height: 190,
              child: Column(
                children: <Widget>[
                  // 标题行
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        widget.news.title,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ClipOval(
                                  child: Image.network(
                                    widget.news.author.userImg,
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  widget.news.author.userName,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.news.postTime,
                                  style: const TextStyle(
                                      fontSize: 9, fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            Text(
                              widget.news.content,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.network(
                        widget.news.contentImg,
                        width: 158,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('未找到图片');
                        },
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
