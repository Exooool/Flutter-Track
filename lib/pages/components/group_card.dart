import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';

class GroupCardController extends GetxController {
  RxInt index = 0.obs;
  RxBool showClose = false.obs;
}

class GroupCard extends StatelessWidget {
  GroupCard({Key? key}) : super(key: key);
  GroupCardController c = Get.put(GroupCardController());

  userItem(int pos, String projectName) {
    return InkWell(
      onTap: () {
        c.index.value = pos;
      },
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image.asset('lib/assets/images/404.jpg',
                fit: BoxFit.cover, height: 48.r, width: 48.r),
          ),
          SizedBox(width: 4.w),
          Visibility(
            visible: pos == c.index.value ? true : false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(projectName,
                    style: TextStyle(fontSize: MyFontSize.font18)),
                Text('在线 每天23:30',
                    style: TextStyle(fontSize: MyFontSize.font12))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<GroupCardController>(builder: (_) {
      return Stack(
        children: [
          PublicCard(
              radius: 90.r,
              onLongPress: () {
                c.showClose.value = !c.showClose.value;
              },
              onTap: () {
                c.showClose.value = false;
              },
              padding: EdgeInsets.all(12.r),
              margin: EdgeInsets.only(
                  left: 24.w, right: 24.w, top: 20.h, bottom: 20.h),
              widget: Row(
                children: <Widget>[
                  userItem(0, '睡前背单词'),
                  SizedBox(width: 8.w),
                  userItem(1, '早起健身'),
                  SizedBox(width: 8.w),
                  userItem(2, 'cpa备考'),
                ],
              )),
          Visibility(
            visible: c.showClose.value,
            child: PublicCard(
                radius: 90.r,
                height: 36.r,
                width: 36.r,
                margin: EdgeInsets.only(left: 24.w),
                widget: Center(
                  child: Image.asset('lib/assets/icons/Close.png',
                      height: 25.r, width: 25.r),
                )),
          )
        ],
      );
    });
  }
}
