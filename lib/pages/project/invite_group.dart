import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/custom_checkbox.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class InviteGroupController extends GetxController {
  RxList selectIndex = [].obs;
  RxList focusList = [].obs;

  _getFocusList() {
    DioUtil().get('/users/focus/info', success: (res) {
      // print(res);
      focusList.value = res['data'];
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

class InviteGroup extends StatelessWidget {
  InviteGroup({Key? key}) : super(key: key);

  final InviteGroupController c = Get.put(InviteGroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          'inviteGroup',
          title: '邀请好友',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
          ending: InkWell(
            onTap: () {
              List list = c.selectIndex.map((e) {
                return c.focusList[e]['user_id'];
              }).toList();

              print('被邀请人：$list');
            },
            child: Image.asset(
              'lib/assets/icons/Send_fill.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
        ),
        body: GetX<InviteGroupController>(builder: (builder) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      title: '短信邀请',
                      shadow: false,
                      height: 44.h,
                      width: 112.w,
                      margin: EdgeInsets.only(
                          left: 6.w, right: 6.w, top: 12.h, bottom: 12.h),
                      onPressed: () {}),
                  CustomButton(
                      title: '复制链接',
                      shadow: false,
                      height: 44.h,
                      width: 112.w,
                      margin: EdgeInsets.only(
                          left: 6.w, right: 6.w, top: 12.h, bottom: 12.h),
                      onPressed: () {}),
                ],
              ),
              Text(
                '最多成立三人小组',
                style: TextStyle(fontSize: 12.sp, color: MyColor.fontBlackO2),
              ),
              Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: c.focusList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (!c.selectIndex.contains(index) &&
                                c.selectIndex.length < 2) {
                              c.selectIndex.add(index);
                            } else {
                              c.selectIndex.remove(index);
                            }
                          },
                          child: ListTile(
                              leading: ClipOval(
                                child: c.focusList[index]['user_img'] == ''
                                    ? Image.asset(
                                        'lib/assets/images/defaultUserImg.png',
                                        height: 56.r,
                                        width: 56.r)
                                    : Image.network(
                                        c.focusList[index]['user_img'],
                                        height: 56.r,
                                        width: 56.r,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(
                                c.focusList[index]['user_name'],
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    fontWeight: FontWeight.w600),
                              ),
                              trailing: Obx(() => CustomCheckBox(
                                  onChanged: (e) {},
                                  value: c.selectIndex.contains(index)))),
                        );
                      }))
            ],
          );
        }));
  }
}
