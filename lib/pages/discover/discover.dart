import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';

import 'package:flutter_track/pages/components/public_card.dart';

import 'package:flutter_track/pages/components/drag_grid.dart';
import 'package:flutter_track/pages/discover/news_search.dart';
import 'package:get/get.dart';

import './news_page.dart';

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
      padding: EdgeInsets.only(left: 14.w, right: 14.w),
      alignment: Alignment.center,
      child: Text(
        content,
        style: TextStyle(
            fontSize: MyFontSize.font16,
            fontFamily: MyFontFamily.pingfangSemibold),
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
  // List<Widget> _getNewsArticle() {
  //   List<Widget> list = [];
  //   var json = data['data'] as Map;
  //   var l = json['news'] as List<dynamic>;
  //   list = l.map((e) {
  //     return ArticleCard(Article.fromMap(e));
  //   }).toList();
  //   return list;
  // }

  // tab栏
  List<Widget> _tabContent() {
    List<Widget> list = _tabList.map((e) {
      return NewsPage(e);
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
                    child: Text('长按拖动排序',
                        style: TextStyle(
                            fontSize: MyFontSize.font14,
                            color: MyColor.fontGrey,
                            fontFamily: MyFontFamily.pingfangMedium)),
                  ),
                  DragGrid(dragList: _tabList, callback: () {}),
                  PublicCard(
                      margin: EdgeInsets.only(top: 25.h),
                      radius: 90.r,
                      height: 48.r,
                      width: 48.r,
                      widget: Center(
                        child: Image.asset('lib/assets/icons/Close.png',
                            height: 33.r, width: 33.r),
                      ))
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
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: PublicCard(
          radius: 90.r,
          height: 72.r,
          width: 72.r,
          onTap: () => Get.toNamed('/newsEdit'),
          margin: EdgeInsets.only(bottom: 122.h),
          widget: Center(
            child: Image.asset('lib/assets/icons/Add.png',
                height: 44.r, width: 44.r),
          ),
        ),
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
                          padding: EdgeInsets.only(left: 10.w, right: 56.w),
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
                              child:
                                  Image.asset('lib/assets/icons/Full_alt.png'),
                              height: 25.r,
                              width: 25.r,
                            )),
                      )
                    ],
                  ),
                  // 搜索框
                  PublicCard(
                    height: 30.h,
                    margin: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w),
                    radius: 60.r,
                    onTap: () => Get.to(() => NewsSearch()),
                    widget: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Opacity(
                              opacity: 0.5,
                              child: Image.asset(
                                'lib/assets/icons/Search_fill.png',
                                height: 24.r,
                                width: 24.r,
                              )),
                          SizedBox(width: 10.w),
                          Text('搜一搜',
                              style: TextStyle(
                                  fontSize: MyFontSize.font14,
                                  color: MyColor.fontBlackO2))
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
