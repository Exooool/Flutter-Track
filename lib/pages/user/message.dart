import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

class MessagePageController extends GetxController {
  final User user = Get.arguments['user'];
  late final io.Socket socket;
  RxList chartMessageList = [].obs;

  getChartMessage() {
    DioUtil().post('/chart/getChartList', success: (res) {
      print(res['data']);
      chartMessageList.value = res['data'];
      update();
    }, error: (error) {
      print(error);
    });
  }

  // 获取最后发送事件 并格式化
  getLastTime(index) {
    List l = jsonDecode(chartMessageList[index]['chart_data']);
    if (l.isNotEmpty) {
      DateTime now = DateTime.now();
      print(now);
      DateTime dateTime = DateTime.parse(l.removeLast()['time']);
      if (dateTime.difference(now).inDays.abs() > 1) {
        return formatDate(dateTime, [yyyy, '.', mm, '.', dd]);
      }
      return formatDate(dateTime, [HH, ':', nn]);
    }
    return '';
  }

  // 获取最后发送的文本
  getLastContent(index) {
    List l = jsonDecode(chartMessageList[index]['chart_data']);
    if (l.isNotEmpty) {
      return l.removeLast()['content'];
    }
    return '';
  }

  // 改变值
  onMessage() {
    update();
  }

  @override
  void onInit() {
    super.onInit();

    // 获取聊天列表
    getChartMessage();

    socket = io.io(
        'http://10.0.2.2:3001',
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.onConnect((_) {
      socket.emit('join', '${user.userId}');
    });
    // socket.on(event, (data) => null)
  }
}

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);
  MessagePageController c = Get.put(MessagePageController());

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

  // 行
  Widget messageRow(String title, String trailing, String img,
      {String subtitle = '', Function()? onTap, bool type = true}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                PublicCard(
                  radius: 90.r,
                  height: 56.r,
                  width: 56.r,
                  widget: type
                      ? ClipOval(
                          child: img == ''
                              ? Image.asset(
                                  'lib/assets/images/defaultUserImg.png')
                              : Image.network(
                                  img,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            img,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: MyFontSize.font16,
                          fontWeight: FontWeight.w600),
                    ),
                    Visibility(
                      visible: subtitle != '',
                      child: Text(subtitle,
                          style: TextStyle(fontSize: MyFontSize.font12)),
                    )
                  ],
                ),
              ],
            ),
            Text(
              trailing,
              style: TextStyle(
                fontSize: MyFontSize.font16,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          'mseeage',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
          ending: InkWell(
            onTap: () {},
            child: Image.asset(
              'lib/assets/icons/Trash.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
        ),
        body: GetBuilder<MessagePageController>(builder: (_) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            // padding: EdgeInsets.only(left: 26.w, right: 26.w),
            children: <Widget>[
              // searchInput(),
              Column(
                children: <Widget>[
                  messageRow('收到的评论', '+22', 'lib/assets/icons/Message-1.png',
                      onTap: () =>
                          Get.to('/chart', arguments: {'socket': c.socket}),
                      type: false),
                  messageRow('被收藏', '+22', 'lib/assets/icons/Message-2.png',
                      type: false),
                  messageRow('官方通知', '+22', 'lib/assets/icons/Message-3.png',
                      type: false),
                  messageRow('陌生人私信', '+22', 'lib/assets/icons/Message-4.png',
                      type: false)
                ],
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  height: 1.h,
                  margin: EdgeInsets.only(
                      left: 26.w, right: 26.w, top: 24.h, bottom: 24.h),
                  decoration: const BoxDecoration(
                      gradient: MyWidgetStyle.mainLinearGradient),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: c.chartMessageList.toList().length,
                  itemBuilder: (context, index) {
                    List l = c.chartMessageList.toList();
                    return messageRow(l[index]['user_name'],
                        c.getLastTime(index), l[index]['user_img'],
                        subtitle: c.getLastContent(index),
                        // 传递socket 和 当前用户对象 以及聊天信息
                        onTap: () => Get.toNamed('/chart', arguments: index));
                  })
            ],
          );
        }));
  }
}
