import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/custom_checkbox.dart';
import 'package:get/get.dart';

class InviteGroupController extends GetxController {
  var selectIndex = 999999.obs;
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
          onTap: () {},
          child: Image.asset(
            'lib/assets/icons/Send_fill.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: Column(
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
                  itemCount: 10,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () {
                        if (c.selectIndex.toInt().isEqual(index)) {
                          c.selectIndex.value = 999;
                        } else {
                          c.selectIndex.value = index;
                        }
                      },
                      child: ListTile(
                          leading: Icon(Icons.file_copy),
                          title: const Text('名字'),
                          trailing: Obx(() => CustomCheckBox(
                              onChanged: (e) {},
                              value: c.selectIndex.value.isEqual(index)))),
                    );
                  }))
        ],
      ),
    );
  }
}
