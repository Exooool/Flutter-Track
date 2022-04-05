import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/discover/article.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPageController extends GetxController {
  RxList list = [].obs;

  _getHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('history') != null) {
      list.value = jsonDecode(prefs.getString('history')!);
      print(jsonDecode(prefs.getString('history')!));
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getHistoryList();
  }
}

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final HistoryPageController c = Get.put(HistoryPageController());

  Widget historyCard(news) {
    return PublicCard(
        radius: 20.r,
        padding:
            EdgeInsets.only(left: 12.w, top: 12.h, bottom: 10.h, right: 12.w),
        margin: EdgeInsets.only(bottom: 20.h),
        onTap: () {
          Get.to(() => ArticlePage(), arguments: {'news_id': news['news_id']});
        },
        widget: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  child: Image.network(news['news_img'],
                      fit: BoxFit.cover, height: 60.h, width: 85.w),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  width: 85.w,
                  child: Text(
                    news['user_name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: MyFontSize.font12,
                        fontFamily: MyFontFamily.pingfangRegular),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 13.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(news['news_title'],
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: MyFontSize.font18,
                            fontFamily: MyFontFamily.pingfangMedium)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          'history',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
        ),
        body: GetX<HistoryPageController>(builder: (_) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: c.list.length,
            itemBuilder: (context, index) {
              return historyCard(c.list[index]);
            },
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
          );
        }));
  }
}
