import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChartPageController extends GetxController {
  var chartList = [].obs;
  final io.Socket socket = Get.arguments['socket'];

  @override
  void onInit() {
    super.onInit();
    socket.on('message', (data) {
      print(data);
    });
  }
}

class ChartPage extends StatelessWidget {
  ChartPage({Key? key}) : super(key: key);
  final ChartPageController c = Get.put(ChartPageController());

  Widget fromChart(String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ClipOval(
            child: Container(
              height: 56.r,
              width: 56.r,
              decoration: const BoxDecoration(
                  gradient: MyWidgetStyle.mainLinearGradient),
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

  Widget toChart(String content) {
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
            child: Container(
              height: 56.r,
              width: 56.r,
              decoration: const BoxDecoration(
                  gradient: MyWidgetStyle.mainLinearGradient),
            ),
          ),
        ],
      ),
    );
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

  List<Widget> getChart(List data) {
    List<Widget> list;
    list = data.map((item) {
      if (item['to']) {
        return toChart(item['content']);
      } else {
        return fromChart(item['content']);
      }
    }).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'chart',
        title: 'Gutabled',
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
                child: ListView(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              physics: const BouncingScrollPhysics(),
              children: getChart(c.chartList.toList()),
            )),
            // 输入框
            input()
          ],
        ),
      ),
    );
  }
}
