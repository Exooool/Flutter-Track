import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/pages/components/article_card.dart';

import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsSearchController extends GetxController {
  RxList searchList = [].obs;
  RxBool searchStatus = false.obs;
  RxList<String> historyList = <String>[].obs;
  RxString searchValue = ''.obs;

  _getHistoryList() async {
    // 从本地存储获取历史搜索
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList('historyList');
    if (list != null) {
      historyList.value = list;
    }
    print(list);
  }

  addHistoryList(value) async {
    if (historyList.length < 8) {
      if (historyList.contains(value)) {
        historyList.remove(value);
        historyList.add(value);
      } else {
        historyList.add(value);
      }
    } else {
      historyList.removeAt(0);
      historyList.add(value);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('historyList', historyList);
  }

  @override
  void onInit() {
    super.onInit();
    _getHistoryList();
  }
}

class NewsSearch extends StatelessWidget {
  NewsSearch({Key? key}) : super(key: key);

  NewsSearchController c = Get.put(NewsSearchController());

  // 搜索方法
  search() {
    DioUtil().post('/news/search', data: {"search": c.searchValue.value},
        success: (res) {
      // print(res);
      c.searchList.value = res['data'];
      c.addHistoryList(c.searchValue.value);
      c.searchStatus.value = true;
      print(c.searchList.length);
    }, error: (error) {});
  }

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
              controller: TextEditingController.fromValue(TextEditingValue(
                  // 设置内容
                  text: c.searchValue.value,
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: c.searchValue.value.length)))),
              onSubmitted: (value) {
                print(value);
                if (value != '') {
                  search();
                }
              },
              onChanged: (value) {
                c.searchValue.value = value;
                if (value == '') {
                  c.searchStatus.value = false;
                }
              },
              style: TextStyle(fontSize: MyFontSize.font14),
              decoration: InputDecoration.collapsed(
                // isDense: true,
                enabled: true,
                hintText: '搜一搜',
                hintStyle: TextStyle(
                    fontSize: MyFontSize.font14,
                    fontFamily: MyFontFamily.pingfangRegular),
              ),
            ))
          ],
        ),
      ),
    );
  }

  // 历史搜索item
  Widget historyItem(String title, int index) {
    return PublicCard(
        radius: 90.r,
        onTap: () {
          c.searchValue.value = title;
          search();
        },
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, top: 4.h, bottom: 4.h),
        widget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: MyFontSize.font12),
            ),
            SizedBox(width: 15.w),
            InkWell(
              onTap: () {
                c.historyList.removeAt(index);
              },
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'lib/assets/icons/Trash.png',
                  height: 25.r,
                  width: 25.r,
                ),
              ),
            )
          ],
        ));
  }

  Widget suggestionItem(String title) {
    return InkWell(
      onTap: () {},
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: MyFontSize.font14,
            fontFamily: MyFontFamily.pingfangRegular),
      ),
    );
  }

  Widget searchContentView() {
    get() {
      List<Widget> list = [];
      for (int i = 0; i < c.historyList.length; i++) {
        list.add(historyItem(c.historyList[i], i));
      }
      return list;
    }

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Text(
            '历史搜索',
            style: TextStyle(
                fontSize: MyFontSize.font16,
                fontFamily: MyFontFamily.pingfangSemibold),
          ),
          alignment: Alignment.centerLeft,
        ),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: get(),
        ),
        Visibility(
          visible: c.historyList.isEmpty ? false : true,
          child: SizedBox(height: 24.h),
        ),
        Visibility(
          visible: c.historyList.isEmpty ? false : true,
          child: PublicCard(
              radius: 90.r,
              onTap: () async {
                // 清除历史搜索
                c.historyList.clear();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setStringList('historyList', c.historyList);
              },
              padding: EdgeInsets.only(
                  left: 12.w, right: 12.w, top: 5.h, bottom: 5.h),
              widget: Text('清除记录',
                  style: TextStyle(
                      fontSize: MyFontSize.font12,
                      fontFamily: MyFontFamily.pingfangRegular,
                      color: MyColor.fontGrey))),
        ),
        Visibility(
          visible: c.historyList.isEmpty ? true : false,
          child: Center(
            child: Text('暂无搜索记录',
                style: TextStyle(
                    fontSize: MyFontSize.font12,
                    fontFamily: MyFontFamily.pingfangMedium)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Text('建议搜索',
              style: TextStyle(
                  fontSize: MyFontSize.font16,
                  fontFamily: MyFontFamily.pingfangSemibold)),
          alignment: Alignment.centerLeft,
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 6.0,
          padding: const EdgeInsets.all(0),
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
            onTap: () {
              Get.snackbar('提示', '暂不支持');
            },
            padding:
                EdgeInsets.only(left: 12.w, right: 12.w, top: 5.h, bottom: 5.h),
            widget: Text('换一换',
                style: TextStyle(
                    fontSize: MyFontSize.font12,
                    color: MyColor.fontGrey,
                    fontFamily: MyFontFamily.pingfangRegular)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return GetX<NewsSearchController>(builder: (controller) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    onTap: () {
                      Get.back();
                      c.searchList.value = [];
                    },
                    child: Image.asset(
                      'lib/assets/icons/Refund_back.png',
                      height: 25.r,
                      width: 25.r,
                    ),
                  ),
                  Expanded(child: searchInput()),
                ],
              ),
              c.searchStatus.value
                  ? Expanded(
                      child: c.searchList.isEmpty
                          ? const Center(child: Text('没有搜索结果'))
                          : ListView.builder(
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
