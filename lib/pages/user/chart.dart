import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
// import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/user/message.dart';
import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;

// class ChartPageController extends GetxController {
//   RxList chartList = [].obs;
//   final io.Socket socket = Get.arguments['socket'];
//   final User user = Get.arguments['user'];
//   late String otherUserImg;
//   late int otherUserId;
//   late int chartId;
//   RxString inputValue = ''.obs;

//   // 初始化聊天状态
//   _getInit() {
//     Map m = Get.arguments['chart_info'];
//     chartList.value = jsonDecode(m['chart_data']);
//     otherUserImg = m['user_img'];
//     otherUserId = m['user_id'];
//     chartId = m['chart_id'];
//   }

//   @override
//   void onInit() {
//     _getInit();
//     socket.on('message', (data) {
//       print(data);
//     });

//     super.onInit();
//   }
// }

class ChartPage extends StatelessWidget {
  ChartPage({Key? key}) : super(key: key);
  // final ChartPageController c = Get.put(ChartPageController());
  final int chartIndex = Get.arguments;
  final TextEditingController controller = TextEditingController();
  final MessagePageController o = Get.find();

  Widget fromChart(String content, String img) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ClipOval(
            child: SizedBox(
              height: 56.r,
              width: 56.r,
              child: img == ''
                  ? Image.asset('lib/assets/images/defaultUserImg.png')
                  : Image.network(
                      img,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          PublicCard(
              radius: 10.r,
              width: 234.w,
              padding: EdgeInsets.all(6.r),
              widget: Text(content))
        ],
      ),
    );
  }

  Widget toChart(String content, String img) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          PublicCard(
              radius: 10.r,
              width: 234.w,
              padding: EdgeInsets.all(6.r),
              widget: Text(content)),
          SizedBox(width: 12.w),
          ClipOval(
            child: SizedBox(
              height: 56.r,
              width: 56.r,
              child: img == ''
                  ? Image.asset('lib/assets/images/defaultUserImg.png')
                  : Image.network(
                      img,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  submit() {
    Map chartData = o.chartMessageList[chartIndex];
    List chartList = jsonDecode(chartData['chart_data']);
    if (controller.text.isNotEmpty) {
      print(controller.text);
      String value = controller.text;
      String now = DateTime.now().toString();

      var newMessage = {
        'time': now,
        'content': value,
        'user_id': o.user.userId
      };
      chartList.add(newMessage);
      o.socket.emit('message',
          [chartList, newMessage, chartData['user_id'], chartData['chart_id']]);
      // 清空输入框
      controller.text = '';
      o.chartMessageList[chartIndex]['chart_data'] = jsonEncode(chartList);
      o.onMessage();
    }
  }

  Widget input() {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: PublicCard(
                radius: 10.r,
                height: 36.h,
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                widget: Center(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) => submit(),
                    decoration: InputDecoration.collapsed(
                      enabled: true,
                      hintText: '请输入你的内容',
                      hintStyle: TextStyle(
                          fontSize: MyFontSize.font16,
                          color: MyColor.fontBlackO2),
                    ),
                  ),
                )),
          ),
          SizedBox(width: 12.w),
          PublicCard(
              radius: 10.r,
              height: 36.h,
              width: 68.w,
              notWhite: true,
              // 通过socket进行发送聊天记录
              onTap: () => submit(),
              widget: Center(
                  child: Text(
                '发送',
                style: TextStyle(
                    fontSize: MyFontSize.font16, color: MyColor.fontWhite),
              )))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessagePageController>(builder: (_) {
      Map chartData = o.chartMessageList[chartIndex];
      List chartList = jsonDecode(chartData['chart_data']);
      return Scaffold(
          appBar: CustomAppbar(
            'chart',
            title: chartData['user_name'],
            leading: InkWell(
              onTap: () => Get.back(),
              child: Image.asset(
                'lib/assets/icons/Refund_back.png',
                height: 25.r,
                width: 25.r,
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  itemCount: chartList.length,
                  itemBuilder: (context, index) {
                    var temp = chartList[index];
                    return temp['user_id'] == o.user.userId
                        ? toChart(temp['content'], o.user.userImg)
                        : fromChart(temp['content'], chartData['user_img']);
                  },
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  physics: const BouncingScrollPhysics(),
                )),
                // 输入框
                input()
              ],
            ),
          ));
    });
  }
}
