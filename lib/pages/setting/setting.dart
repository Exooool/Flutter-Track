import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/expansion_list.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  Widget itemRow(String title, {Function()? onTap, bool inner = true}) {
    return InkWell(
      onTap: onTap,
      child: PublicCard(
          height: inner ? 24.h : 36.h,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
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
                        height: 24.h,
                        width: 93.w,
                        radius: 90.r,
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
                      height: 24.h,
                      radius: 90.r,
                      padding: EdgeInsets.only(right: 24.w),
                      widget: Text('17722801204',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              height: 1.5,
                              fontSize: MyFontSize.font14,
                              color: MyColor.fontBlack)),
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
                    height: 24.h,
                    padding: EdgeInsets.only(left: 12.w),
                    margin: EdgeInsets.only(bottom: 12.h),
                    widget: Text('对外收藏可见',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: MyFontSize.font14,
                            fontWeight: FontWeight.w600,
                            color: MyColor.fontWhite)),
                    notWhite: true,
                  )
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
