import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';

class NewsSearch extends StatelessWidget {
  const NewsSearch({Key? key}) : super(key: key);

  // 搜索框
  Widget searchInput() {
    return PublicCard(
      height: 30.h,
      margin: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w, bottom: 12.h),
      radius: 60.r,
      widget: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              size: 14.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
                child: TextField(
              onTap: () {
                print('跳转搜索页');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () => Get.back(),
                  child: Text('返回'),
                ),
                Expanded(child: searchInput()),
              ],
            ),
            Container(
              child: Text('历史搜索'),
              alignment: Alignment.centerLeft,
            ),
            PublicCard(radius: 90.r, widget: Text('清除记录')),
            Container(
              child: Text('建议搜索'),
              alignment: Alignment.centerLeft,
            ),
            Column(
              children: <Widget>[],
            ),
            PublicCard(radius: 90.r, widget: Text('换一换'))
          ],
        ),
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
