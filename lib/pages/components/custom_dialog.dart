import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';

import 'package:flutter_track/pages/components/public_card.dart';

class CustomDialog extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final String content;
  final String? subContent;
  final Function()? onConfirm;
  final Function()? onCancel;
  const CustomDialog(
      {Key? key,
      required this.height,
      required this.width,
      required this.title,
      required this.content,
      this.subContent,
      this.onConfirm,
      this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: Stack(
          children: [
            // 背景虚化
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // dialog
            Center(
              child: SizedBox(
                height: height,
                width: width,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                          color: Colors.white.withOpacity(0.1)),
                      child: PublicCard(
                          radius: 20.r,
                          padding: EdgeInsets.only(top: 48.h, bottom: 36.h),
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // 标题
                              Center(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: MyFontSize.font19,
                                      foreground:
                                          MyFontStyle.textlinearForeground,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),

                              // 内容

                              Center(
                                  child: DefaultTextStyle(
                                      style: TextStyle(
                                          fontSize: MyFontSize.font14,
                                          foreground:
                                              MyFontStyle.textlinearForeground,
                                          fontWeight: FontWeight.w600),
                                      child: Column(
                                        children: [
                                          Text(content),
                                          subContent != null
                                              ? Text(subContent!)
                                              : Container()
                                        ],
                                      ))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  PublicCard(
                                      radius: 90.r,
                                      notWhite: true,
                                      onTap: onCancel,
                                      padding: EdgeInsets.only(
                                          left: 24.w,
                                          right: 24.w,
                                          top: 13.h,
                                          bottom: 13.h),
                                      widget: Text('取消',
                                          style: TextStyle(
                                              color: MyColor.fontWhite,
                                              fontSize: MyFontSize.font16))),
                                  SizedBox(width: 12.h),
                                  PublicCard(
                                      radius: 90.r,
                                      notWhite: true,
                                      onTap: onConfirm,
                                      padding: EdgeInsets.only(
                                          left: 24.w,
                                          right: 24.w,
                                          top: 13.h,
                                          bottom: 13.h),
                                      widget: Text('确认',
                                          style: TextStyle(
                                              color: MyColor.fontWhite,
                                              fontSize: MyFontSize.font16)))
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
