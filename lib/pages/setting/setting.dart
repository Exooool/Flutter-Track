import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_dialog.dart';
import 'package:flutter_track/pages/components/expansion_list.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/setting/setting_controller.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);
  final SettingController c = Get.put(SettingController());
  final UserController u = Get.find();

  Widget itemRow(String title, {Function()? onTap, bool inner = true}) {
    return InkWell(
      onTap: onTap,
      child: PublicCard(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: inner
              ? EdgeInsets.only(left: 24.w, right: 24.w, top: 5.h, bottom: 5.h)
              : EdgeInsets.only(left: 24.w, right: 24.w, top: 8.h, bottom: 8.h),
          radius: 90.r,
          notWhite: inner,
          widget: Row(
            mainAxisAlignment:
                inner ? MainAxisAlignment.center : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: inner ? MyColor.fontWhite : MyColor.fontBlack,
                    fontSize: inner ? MyFontSize.font14 : MyFontSize.font16,
                    fontFamily: MyFontFamily.pingfangSemibold),
              )
            ],
          )),
    );
  }

  Widget toggle() {
    return Obx(() => Row(children: <Widget>[
          PublicCard(
              radius: 90.r,
              padding:
                  EdgeInsets.only(left: 9.w, right: 9.w, top: 1.h, bottom: 1.h),
              margin: EdgeInsets.only(left: 9.w),
              onTap: () => c.private.value = 0,
              widget: Text('???',
                  style: TextStyle(
                      foreground: c.private.value == 0
                          ? MyFontStyle.textlinearForeground
                          : null,
                      color: c.private.value == 1 ? MyColor.fontBlackO2 : null,
                      fontSize: MyFontSize.font16,
                      fontFamily: MyFontFamily.pingfangRegular))),
          PublicCard(
              radius: 90.r,
              padding:
                  EdgeInsets.only(left: 9.w, right: 9.w, top: 1.h, bottom: 1.h),
              margin: EdgeInsets.only(left: 9.w),
              onTap: () => c.private.value = 1,
              widget: Text('???',
                  style: TextStyle(
                      foreground: c.private.value == 1
                          ? MyFontStyle.textlinearForeground
                          : null,
                      color: c.private.value == 0 ? MyColor.fontBlackO2 : null,
                      fontSize: MyFontSize.font16,
                      fontFamily: MyFontFamily.pingfangRegular)))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        '',
        leading: InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
        title: '??????',
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 24.h),
        children: <Widget>[
          ExpansionList(
            title: '????????????',
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: <Widget>[
                    PublicCard(
                        width: 93.w,
                        radius: 90.r,
                        padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                        margin: EdgeInsets.only(right: 11.w),
                        widget: Center(
                          child: Text('????????????',
                              style: TextStyle(
                                  fontSize: MyFontSize.font14,
                                  fontFamily: MyFontFamily.pingfangMedium,
                                  color: MyColor.fontWhite)),
                        ),
                        notWhite: true),
                    Expanded(
                        child: PublicCard(
                      radius: 90.r,
                      padding:
                          EdgeInsets.only(top: 5.h, bottom: 5.h, right: 24.w),
                      widget: Text(u.user.value.mobile,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: MyFontSize.font14,
                              color: MyColor.fontBlack,
                              fontWeight: FontWeight.w600)),
                    ))
                  ],
                ),
              ),
              itemRow('???????????????'),
              itemRow('????????????')
            ],
            headerRadius: BorderRadius.all(Radius.circular(90.r)),
            height: 36.h,
            headerPadding: EdgeInsets.only(left: 24.w, right: 14.w),
          ),
          ExpansionList(
            title: '????????????',
            children: [
              itemRow('??????'),
              itemRow('??????/??????'),
              itemRow('?????????'),
              itemRow('?????????'),
              itemRow('??????')
            ],
            headerRadius: BorderRadius.all(Radius.circular(90.r)),
            height: 36.h,
            headerPadding: EdgeInsets.only(left: 24.w, right: 14.w),
          ),
          ExpansionList(
            title: '????????????',
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: PublicCard(
                      radius: 90.r,
                      padding:
                          EdgeInsets.only(left: 12.w, top: 5.h, bottom: 5.h),
                      widget: Text('??????????????????',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: MyFontSize.font14,
                              fontFamily: MyFontFamily.pingfangSemibold,
                              color: MyColor.fontWhite)),
                      notWhite: true,
                    )),
                    toggle()
                  ],
                ),
              )
            ],
            headerRadius: BorderRadius.all(Radius.circular(90.r)),
            height: 36.h,
            headerPadding: EdgeInsets.only(left: 24.w, right: 14.w),
          ),
          itemRow('????????????', inner: false),
          itemRow('????????????', inner: false),
          itemRow('????????????', inner: false),
          itemRow('????????????', inner: false),
          itemRow('????????????', inner: false, onTap: () {
            Get.dialog(
              CustomDialog(
                height: 330.h,
                width: 318.w,
                title: '??????',
                content: '??????????????????????????????',
                onCancel: () {
                  Get.back();
                },
                onConfirm: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('token', '');
                  Get.offAllNamed('/log');
                },
              ),
              barrierColor: Colors.transparent,
            );
          }),
        ],
      ),
    );
  }
}
