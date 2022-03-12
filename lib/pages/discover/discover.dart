import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/article_card.dart';
import 'package:flutter_track/pages/components/public_card.dart';

import 'package:flutter_track/pages/components/drag_grid.dart';

import './news_page.dart';

import 'package:flutter_track/model/news_model.dart';
import 'package:flutter_track/assets/test.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 自定义tab样式
  Widget _customTab(String content) {
    return Container(
      height: 24.h,
      width: 60.w,
      alignment: Alignment.center,
      child: Text(
        content,
        style: TextStyle(fontSize: MyFontSize.font16),
      ),
    );
  }

  final _tabList = const [
    '关注',
    '推荐',
    '校园',
    '语言',
    '升学',
    '心理',
    '文学',
    '生活',
    '运动',
    '读书',
    '哲学',
    '法学',
    '经济学',
    '艺术学',
    '教育学',
    '历史学',
    '理学',
    '工学',
    '农学',
    '医学',
    '管理学',
    '其它'
  ];

  List dataList = [];

  // 获取资讯列表
  List<Widget> _getNewsArticle() {
    List<Widget> list = [];
    var json = data['data'] as Map;
    var l = json['news'] as List<dynamic>;
    list = l.map((e) {
      return ArticleCard(Article.fromMap(e));
    }).toList();
    return list;
  }

  //
  List<Widget> _tabContent() {
    List<Widget> list = _tabList.map((e) {
      return NewsPage(_getNewsArticle(), e);
    }).toList();
    return list;
  }

  // 标签分类排序
  showSortTabItem() {
    // 底部弹窗
    // 对tab栏进行排序

    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // 切割很重要
            ClipRect(
              child: SizedBox(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: MyWidgetStyle.secondLinearGradient),
                  ),
                ),
              ),
            ),

            PublicCard(
              radius: 10.r,
              height: double.maxFinite,
              width: double.maxFinite,
              widget: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30.h, bottom: 30.h),
                    child: const Text('长按拖动排序'),
                  ),
                  DragGrid(dragList: _tabList, callback: () {})
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _tabList.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    // 销毁tabController
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(
              top: MediaQueryData.fromWindow(window).padding.top + 12.h),
          child: Column(
            children: <Widget>[
              // tab栏
              Column(
                children: <Widget>[
                  // tabbar栏
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 10.w, right: 46.w),
                          child: TabBar(
                            physics: const BouncingScrollPhysics(),
                            // padding: const EdgeInsets.all(0),
                            labelColor: const Color.fromRGBO(240, 242, 243, 1),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            unselectedLabelStyle:
                                const TextStyle(fontWeight: FontWeight.normal),
                            unselectedLabelColor:
                                const Color.fromRGBO(0, 0, 0, 1),
                            // 更改指示点样式
                            indicator: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.r)),
                                gradient: MyWidgetStyle.mainLinearGradient),
                            // indicatorSize: TabBarIndicatorSize.label,

                            labelPadding: const EdgeInsets.all(0),
                            isScrollable: true,
                            tabs: _tabList.map((e) {
                              return _customTab(e);
                            }).toList(),
                            controller: _tabController,
                          )),
                      // 菜单按钮
                      Positioned(
                        right: 26.w,
                        child: InkWell(
                            onTap: () {
                              showSortTabItem();
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: const Icon(Icons.menu),
                            )),
                      )
                    ],
                  ),
                  // 搜索框
                  PublicCard(
                    height: 30.h,
                    margin: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w),
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
                  )
                ],
              ),
              // tabview显示
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: _tabContent(),
                physics: const BouncingScrollPhysics(),
              ))
            ],
          ),
        ));
  }
}
