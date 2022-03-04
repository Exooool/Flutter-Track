import 'package:flutter/material.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/expansion_list.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  Widget itemRow(String title,
      {Function()? function,
      MainAxisAlignment alignment = MainAxisAlignment.start,
      bool inner = true}) {
    return InkWell(
      onTap: function,
      child: Opacity(
        opacity: inner ? 0.5 : 1,
        child: Container(
          height: inner ? 24 : 36,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(left: 24, right: 24),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80)),
              gradient: MyWidgetStyle.mainLinearGradient),
          child: Row(
            mainAxisAlignment: alignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: MyColor.fontWhite,
                    fontSize: inner ? MyFontSize.font14 : MyFontSize.font16,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        '',
        leading: InkWell(
          onTap: () {},
          child: const Text('返回'),
        ),
        title: '设置',
        ending: InkWell(
          onTap: () {},
          child: const Text('保存'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        children: <Widget>[
          ExpansionList(
            title: '账号安全',
            children: [
              itemRow('第三方软件', alignment: MainAxisAlignment.center),
              itemRow('更改密码', alignment: MainAxisAlignment.center),
              itemRow('注销账号', alignment: MainAxisAlignment.center)
            ],
            headerRadius: const BorderRadius.all(Radius.circular(80)),
            height: 36,
            headerPadding: const EdgeInsets.only(left: 24, right: 14),
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
            headerRadius: const BorderRadius.all(Radius.circular(80)),
            height: 36,
            headerPadding: const EdgeInsets.only(left: 24, right: 14),
          ),
          itemRow('名单管理', inner: false),
          itemRow('关于我们', inner: false),
          itemRow('意见反馈', inner: false),
          itemRow('联系我们', inner: false),
          itemRow('退出登陆', inner: false),
        ],
      ),
    );
  }
}
