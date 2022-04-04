import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/expansion_list.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/setting/setting_controller.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
                    fontWeight: FontWeight.w600),
              )
            ],
          )),
    );
  }

  Widget formSwitch(String on, String off, int value, Function onChange) {
    return ToggleSwitch(
      minWidth: on.length == 1 ? 40.sp : 100.sp,
      fontSize: MyFontSize.font16,
      minHeight: 25.h,
      radiusStyle: true,
      cornerRadius: 60.r,
      inactiveBgColor: Colors.transparent,
      activeFgColor: Colors.white,
      inactiveFgColor: MyColor.fontBlackO2,
      activeBgColor: const [MyColor.mainColor, MyColor.secondColor],
      initialLabelIndex: value,
      totalSwitches: 2,
      labels: [on, off],
      onToggle: (index) {
        onChange(index);
      },
    );
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
        title: '设置',
        ending: InkWell(
          onTap: () {},
          child: const Text('保存'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 24.h),
        children: <Widget>[
          ExpansionList(
            title: '账号安全',
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
                          child: Text('手机号码',
                              style: TextStyle(
                                  fontSize: MyFontSize.font14,
                                  fontWeight: FontWeight.w600,
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
              itemRow('第三方软件'),
              itemRow('注销账号')
            ],
            headerRadius: BorderRadius.all(Radius.circular(90.r)),
            height: 36.h,
            headerPadding: EdgeInsets.only(left: 24.w, right: 14.w),
          ),
          ExpansionList(
            title: '系统权限',
            children: [
              itemRow('位置'),
              itemRow('相机/照片'),
              itemRow('麦克风'),
              itemRow('通讯录'),
              itemRow('通知')
            ],
            headerRadius: BorderRadius.all(Radius.circular(90.r)),
            height: 36.h,
            headerPadding: EdgeInsets.only(left: 24.w, right: 14.w),
          ),
          ExpansionList(
            title: '隐私设置',
            children: [
              Row(
                children: [
                  PublicCard(
                    radius: 90.r,
                    width: 254.w,
                    padding: EdgeInsets.only(left: 12.w, top: 5.h, bottom: 5.h),
                    margin: EdgeInsets.only(bottom: 12.h),
                    widget: Text('对外收藏可见',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: MyFontSize.font14,
                            fontWeight: FontWeight.w600,
                            color: MyColor.fontWhite)),
                    notWhite: true,
                  ),
                  formSwitch('是', '否', c.private.value, (index) {
                    c.private.value = index;
                    print('分阶段完成：${c.private.value}');
                  })
                ],
              )
            ],
            headerRadius: BorderRadius.all(Radius.circular(90.r)),
            height: 36.h,
            headerPadding: EdgeInsets.only(left: 24.w, right: 14.w),
          ),
          itemRow('名单管理', inner: false),
          itemRow('关于我们', inner: false),
          itemRow('意见反馈', inner: false),
          itemRow('联系我们', inner: false),
          itemRow('退出登陆', inner: false, onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', '');
            Get.offAllNamed('/log');
          }),
        ],
      ),
    );
  }
}
