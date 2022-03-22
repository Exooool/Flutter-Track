import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/article_card.dart';

import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class NewsSearchController extends GetxController {
  RxList searchList = [].obs;
}

class NewsSearch extends StatelessWidget {
  NewsSearch({Key? key}) : super(key: key);

  NewsSearchController c = Get.put(NewsSearchController());

  // 搜索框
  Widget searchInput() {
    return PublicCard(
      height: 35.h,
      margin: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w, bottom: 12.h),
      radius: 60.r,
      widget: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/icons/Search_fill.png',
              height: 25.r,
              width: 25.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
                child: TextField(
              onSubmitted: (value) {
                if (value != '') {
                  DioUtil().post('/news/search', data: {"search": value},
                      success: (res) {
                    print(res);
                    c.searchList.value = res['data'];
                    print(c.searchList.length);
                  }, error: (error) {});
                }
              },
              onChanged: (value) {
                if (value == '') {
                  c.searchList.value = [];
                }
              },
              style: TextStyle(fontSize: MyFontSize.font14),
              decoration: InputDecoration.collapsed(
                // isDense: true,
                enabled: true,
                hintText: '搜一搜',

                hintStyle: TextStyle(fontSize: MyFontSize.font14),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget historyItem(String title) {
    return PublicCard(
        radius: 90.r,
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, top: 4.h, bottom: 4.h),
        widget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: MyFontSize.font12),
            ),
            Icon(Icons.close)
          ],
        ));
  }

  Widget suggestionItem(String title) {
    return InkWell(
      onTap: () {},
      child: Text(
        title,
        style: TextStyle(fontSize: MyFontSize.font14),
      ),
    );
  }

  Widget searchContentView() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Text(
            '历史搜索',
            style: TextStyle(
                fontSize: MyFontSize.font16, fontWeight: FontWeight.w600),
          ),
          alignment: Alignment.centerLeft,
        ),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: <Widget>[historyItem('关于如何提高自己的管理能力'), historyItem('版式设计')],
        ),
        SizedBox(height: 24.h),
        PublicCard(
            radius: 90.r,
            padding:
                EdgeInsets.only(left: 12.w, right: 12.w, top: 5.h, bottom: 5.h),
            widget: Text('清除记录',
                style: TextStyle(
                    fontSize: MyFontSize.font12, color: MyColor.fontGrey))),
        Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Text('建议搜索',
              style: TextStyle(
                  fontSize: MyFontSize.font16, fontWeight: FontWeight.w600)),
          alignment: Alignment.centerLeft,
        ),
        Wrap(
          spacing: 60.w,
          runSpacing: 12.h,
          children: <Widget>[
            suggestionItem('在校时期养成学习好习...'),
            suggestionItem('浅谈职业目标的重要性'),
            suggestionItem('大学生拖延症现象的学...'),
            suggestionItem('如何有效坚持自己的目标'),
            suggestionItem('有关提高学习能力的电影'),
            suggestionItem('兼职与投入学习的利弊'),
            suggestionItem('读完这本《学习高手》...'),
            suggestionItem('疫情防范的正确方式'),
          ],
        ),
        SizedBox(height: 24.h),
        PublicCard(
            radius: 90.r,
            padding:
                EdgeInsets.only(left: 12.w, right: 12.w, top: 5.h, bottom: 5.h),
            widget: Text('换一换',
                style: TextStyle(
                    fontSize: MyFontSize.font12, color: MyColor.fontGrey)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<NewsSearchController>(builder: (controller) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
              top: MediaQueryData.fromWindow(window).padding.top + 15.h,
              left: 24.w,
              right: 24.w),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'lib/assets/icons/Refund_back.png',
                      height: 25.r,
                      width: 25.r,
                    ),
                  ),
                  Expanded(child: searchInput()),
                ],
              ),
              c.searchList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: c.searchList.length,
                          itemBuilder: (context, index) {
                            return ArticleCard(
                                Article.fromMap(c.searchList[index]));
                          }),
                    )
                  : Expanded(child: searchContentView())
            ],
          ),
        ),
      );
    });
  }
}
