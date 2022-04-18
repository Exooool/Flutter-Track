import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class FocusListController extends GetxController {
  // 从传递的参数获取当前列表类型
  final int type = Get.arguments['type'];
  RxList focusList = [].obs;

  _getFocusList() {
    DioUtil().post('/users/getFocusOrBefocusList', data: {'type': type},
        success: (res) {
      print(res);
      focusList.value = (res['data'] as List).map((item) {
        item['focused'] = true;
        return item;
      }).toList();
      update();
      print(focusList);
    }, error: (error) {
      print(error);
    });
  }

  @override
  void onInit() {
    super.onInit();
    _getFocusList();
  }
}

class FocusList extends StatelessWidget {
  FocusList({Key? key}) : super(key: key);
  final FocusListController c = Get.put(FocusListController());

  Widget userItem(Map m) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: m['user_img'] == ''
                      ? Image.asset(
                          'lib/assets/images/defaultUserImg.png',
                          height: 56.r,
                          width: 56.r,
                        )
                      : Image.network(
                          m['user_img'],
                          height: 56.r,
                          width: 56.r,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                    child: Text(
                  m['user_name'],
                  style: TextStyle(
                      fontSize: MyFontSize.font16, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
          ),
          Opacity(
            opacity: m['focused'] ? 0.5 : 1,
            child: PublicCard(
                radius: 90.r,
                notWhite: true,
                onTap: () {},
                padding: EdgeInsets.only(
                    left: 35.w, right: 35.w, top: 10.h, bottom: 10.h),
                widget: Text(
                  c.type == 0 ? '取关' : '回关',
                  style: TextStyle(
                      fontSize: MyFontSize.font16, color: MyColor.fontWhite),
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          '',
          title: c.type == 0 ? '我的关注' : '我的粉丝',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
        ),
        body: GetBuilder<FocusListController>(
          builder: (_) {
            return ListView.builder(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
                itemCount: c.focusList.length,
                itemBuilder: (context, index) {
                  return userItem(c.focusList[index]);
                });
          },
        ));
  }
}
