import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

class MessagePageController extends GetxController {
  final User user = Get.arguments['user'];
  late final io.Socket socket;
  var chartMessageList = [
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'},
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'},
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'},
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'},
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'},
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'},
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'},
    {'name': 'Gutabled', 'content': '私信内容。。。', 'time': '19:00'}
  ].obs;

  @override
  void onInit() {
    super.onInit();
    socket = io.io(
        'http://10.0.2.2:3001',
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.onConnect((_) {
      socket.emit('join', '${user.userId}');
    });
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
  Widget messageRow(String title, String trailing, {String subtitle = ''}) {
    return InkWell(
      onTap: () => Get.toNamed('/chart', arguments: {'socket': c.socket}),
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                ClipOval(
                  child: Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: const BoxDecoration(
                        gradient: MyWidgetStyle.mainLinearGradient),
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

  // 获取私信
  List<Widget> getMessage(List data) {
    List<Widget> list;
    list = data.map((e) {
      return messageRow(e['name'], e['time'], subtitle: e['content']);
    }).toList();
    return list;
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
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        // padding: EdgeInsets.only(left: 26.w, right: 26.w),
        children: <Widget>[
          searchInput(),
          Column(
            children: <Widget>[
              messageRow('收到的评论', '+22'),
              messageRow('被收藏', '+22'),
              messageRow('官方通知', '+22'),
              messageRow('陌生人私信', '+22')
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
          Column(
            children: getMessage(c.chartMessageList.toList()),
          )
        ],
      ),
    );
  }
}
