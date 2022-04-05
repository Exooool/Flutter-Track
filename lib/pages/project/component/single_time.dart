import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';

import 'package:flutter_track/pages/components/public_card.dart';

import 'package:get/get.dart';

class SingleTime extends StatefulWidget {
  final Function onChanged;
  SingleTime(this.onChanged, {Key? key}) : super(key: key);

  @override
  State<SingleTime> createState() => _SingleTimeState();
}

class _SingleTimeState extends State<SingleTime> {
  int singleTime = 0;
  int customTime = 0;
  // 单次时长
  Widget customRadio(String title, Function() ontap, bool selected) {
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: PublicCard(
        onTap: () {
          ontap();
          setState(() {});
        },
        radius: 90.r,
        notWhite: true,
        widget: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: MyFontSize.font16,
                color: MyColor.fontWhite,
                fontFamily: MyFontFamily.pingfangMedium),
          ),
        ),
        height: 36.h,
        width: 76.w,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: 36.w, right: 36.w, top: 24.h, bottom: 47.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () => Get.back(),
                child: Text(
                  '取消',
                  style: TextStyle(
                      fontSize: MyFontSize.font16,
                      foreground: MyFontStyle.textlinearForeground,
                      fontFamily: MyFontFamily.pingfangSemibold),
                ),
              ),
              InkWell(
                onTap: () {
                  var time = {'type': singleTime, 'custom': customTime};
                  if (singleTime == 5 && customTime == 0) {
                    Get.back();
                    Get.snackbar('提示', '自定义时间不要为空');
                  } else {
                    widget.onChanged(time);
                    Get.back();
                  }
                  print(time);
                },
                child: Text(
                  '确认',
                  style: TextStyle(
                      fontSize: MyFontSize.font16,
                      foreground: MyFontStyle.textlinearForeground,
                      fontFamily: MyFontFamily.pingfangSemibold),
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 24.w,
          mainAxisSpacing: 24.h,
          childAspectRatio: 2.0,
          padding: EdgeInsets.only(left: 69.w, right: 69.w, bottom: 24.h),
          children: <Widget>[
            customRadio('30分钟', () {
              singleTime = 0;
            }, singleTime == 0 ? true : false),
            customRadio('60分钟', () {
              singleTime = 1;
            }, singleTime == 1 ? true : false),
            customRadio('90分钟', () {
              singleTime = 2;
            }, singleTime == 2 ? true : false),
            customRadio('120分钟', () {
              singleTime = 3;
            }, singleTime == 3 ? true : false),
            customRadio('150分钟', () {
              singleTime = 4;
            }, singleTime == 4 ? true : false),
            customRadio('自定义', () {
              singleTime = 5;
            }, singleTime == 5 ? true : false),
          ],
        ),
        Center(
          child: PublicCard(
            height: 36.h,
            width: 76.w,
            radius: 90.r,
            widget: TextField(
                textAlign: TextAlign.center,
                maxLength: 4,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value != '') {
                    customTime = int.parse(value);
                  } else {
                    customTime = 0;
                  }
                },
                // 限制输入为数字
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                    fontSize: MyFontSize.font16,
                    fontWeight: FontWeight.w500,
                    foreground: MyFontStyle.textlinearForeground),
                decoration: const InputDecoration(
                    border: InputBorder.none, counterText: '')),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              '单位为分钟',
              style: TextStyle(
                  fontSize: MyFontSize.font10, color: MyColor.fontGrey),
            ),
          ),
        )
      ],
    );
  }
}
