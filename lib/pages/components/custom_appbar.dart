import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';

// 发现页appbar的tab切换
Widget discoverTitle() {
  return const SizedBox(
    child: TabBar(
        // 隐藏指示点
        isScrollable: true,
        labelPadding: EdgeInsets.only(left: 9, right: 9),
        labelStyle: TextStyle(
            fontSize: 20,
            color: MyColor.fontBlack,
            fontWeight: FontWeight.w600),
        labelColor: MyColor.fontBlack,
        unselectedLabelColor: MyColor.fontBlack,
        unselectedLabelStyle: TextStyle(fontSize: 15),
        padding: EdgeInsets.all(0),
        indicator: BoxDecoration(color: Colors.transparent),
        tabs: <Widget>[
          Tab(
            text: '资讯',
          ),
          Tab(
            text: '动态',
          )
        ]),
  );
}

class CustomAppbar extends AppBar {
  CustomAppbar(String page,
      {Key? key,
      String title = '',
      Widget? titleWidget,
      Widget? leading,
      Widget? ending})
      : super(
          key: key,
          // 去除阴影
          // elevation: 0,
          leading: leading == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Center(
                    child: leading,
                  ),
                ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 26.w),
              child: Center(
                child: ending,
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          // 设置appbar底部左右圆角边框
          // shape: const RoundedRectangleBorder(
          //     side: BorderSide.none,
          //     borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(20),
          //         bottomRight: Radius.circular(20))),
          // 弹性空间 设置appbar背景渐变色
          // flexibleSpace: Container(
          //   // 设置内部container的圆角
          //   decoration: const BoxDecoration(
          //       boxShadow: [
          //         BoxShadow(
          //           color: Color.fromRGBO(56, 86, 244, 0.4), // 阴影的颜色
          //           offset: Offset(0, 6), // 阴影与容器的距离
          //           blurRadius: 10, // 高斯的标准偏差与盒子的形状卷积。
          //           spreadRadius: 0, // 在应用模糊之前，框应该膨胀的量。
          //         ),
          //       ],
          //       borderRadius: BorderRadius.only(
          //           bottomLeft: Radius.circular(20),
          //           bottomRight: Radius.circular(20)),
          //       // 设置线性渐变
          //       gradient: LinearGradient(
          //           begin: Alignment.centerLeft,
          //           end: Alignment.centerRight,
          //           colors: [
          //             Color.fromRGBO(107, 101, 244, 1),
          //             Color.fromRGBO(51, 84, 244, 1)
          //           ])),
          // ),
          titleSpacing: 0,
          title: page == 'discover'
              ? discoverTitle()
              : titleWidget ??
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: MyFontSize.font19,
                        fontFamily: MyFontFamily.pingfangSemibold,
                        color: MyColor.fontBlack),
                  ),
          centerTitle: true,
        );
}
