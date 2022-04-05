import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
// import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/user/message.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;

// class ChartPageController extends GetxController {
//   final ScrollController scrollController = ScrollController();

//   @override
//   void onInit() {
//     scrollController.jumpTo(scrollController.position.maxScrollExtent);
//   }
// }

class ChartPage extends StatelessWidget {
  ChartPage({Key? key}) : super(key: key);
  // final ChartPageController c = Get.put(ChartPageController());
  final int chartIndex = Get.arguments;
  final TextEditingController controller = TextEditingController();
  final MessagePageController o = Get.find();
  // final ChartPageController c = Get.put(ChartPageController());

  Widget fromChart(String content, String img) {
    int idIndex = content.indexOf('#*');
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Container(
            constraints: BoxConstraints(
              maxWidth: 234.w,
            ),
            child: PublicCard(
                radius: 10.r,
                margin: EdgeInsets.only(top: 20.h),
                padding: EdgeInsets.only(
                    top: 6.r, bottom: 6.r, left: 12.r, right: 12.r),
                widget: content.contains('#*')
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                          text: content.substring(0, idIndex),
                          style: TextStyle(
                              fontFamily: MyFontFamily.pingfangRegular,
                              fontSize: MyFontSize.font16,
                              color: Colors.black),
                        ),
                        TextSpan(
                            text: '同意请点击此处',
                            style: TextStyle(
                                fontFamily: MyFontFamily.pingfangRegular,
                                fontSize: MyFontSize.font16,
                                foreground: MyFontStyle.textlinearForeground),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                List l = content
                                    .substring(idIndex + 2, content.length)
                                    .split('#*');
                                int projectId = int.parse(l[0]);
                                int groupId = int.parse(l[1]);
                                DioUtil().post('/project/acceptInvite', data: {
                                  'project_id': projectId,
                                  'group_id': groupId
                                }, success: (res) {
                                  print(res);
                                  if (res['status'] == 2) {
                                    Get.snackbar('提示', '你已经加入该互助小组，请不要重复点击');
                                  }
                                }, error: (error) {
                                  print(error);
                                });
                                print('$projectId,$groupId');
                              })
                      ]))
                    : Text(content,
                        style: TextStyle(
                            fontFamily: MyFontFamily.pingfangRegular,
                            fontSize: MyFontSize.font16))),
          )
        ],
      ),
    );
  }

  Widget toChart(String content, String img) {
    int idIndex = content.indexOf('#*');
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: 234.w,
            ),
            child: PublicCard(
                radius: 10.r,
                margin: EdgeInsets.only(top: 20.h),
                padding: EdgeInsets.only(
                    top: 6.r, bottom: 6.r, left: 12.r, right: 12.r),
                widget: content.contains('#*')
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                          text: content.substring(0, idIndex),
                          style: TextStyle(
                              fontFamily: MyFontFamily.pingfangRegular,
                              fontSize: MyFontSize.font16,
                              color: Colors.black),
                        ),
                        TextSpan(
                            text: '同意请点击此处',
                            style: TextStyle(
                                fontFamily: MyFontFamily.pingfangRegular,
                                fontSize: MyFontSize.font16,
                                foreground: MyFontStyle.textlinearForeground),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                List l = content
                                    .substring(idIndex + 2, content.length)
                                    .split('#*');
                                int projectId = int.parse(l[0]);
                                int groupId = int.parse(l[1]);
                                DioUtil().post('/project/acceptInvite', data: {
                                  'project_id': projectId,
                                  'group_id': groupId
                                }, success: (res) {
                                  print(res);
                                  if (res['status'] == 2) {
                                    Get.snackbar('提示', '你已经加入该互助小组，请不要重复点击');
                                  }
                                }, error: (error) {
                                  print(error);
                                });
                                print('$projectId,$groupId');
                              })
                      ]))
                    : Text(content,
                        style: TextStyle(
                            fontFamily: MyFontFamily.pingfangRegular,
                            fontSize: MyFontSize.font16))),
          ),
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
                  // controller: c.scrollController,
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
