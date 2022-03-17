import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard(this.project, {Key? key}) : super(key: key);

  // 颜色对应
  // final Map<String, Color> tfColor = const {
  //   "fColor1": Color.fromRGBO(255, 128, 128, 1),
  //   "fColor2": Color.fromRGBO(255, 191, 128, 1),
  //   "fColor3": Color.fromRGBO(255, 255, 128, 1),
  //   "fColor4": Color.fromRGBO(191, 255, 128, 1),
  //   "fColor5": Color.fromRGBO(128, 255, 128, 1),
  //   "fColor6": Color.fromRGBO(128, 255, 191, 1),
  //   "fColor7": Color.fromRGBO(128, 255, 255, 1),
  //   "fColor8": Color.fromRGBO(128, 191, 255, 1),
  //   "fColor9": Color.fromRGBO(128, 128, 255, 1),
  //   "fColor10": Color.fromRGBO(191, 128, 255, 1),
  //   "fColor11": Color.fromRGBO(255, 128, 255, 1),
  //   "fColor12": Color.fromRGBO(255, 128, 191, 1),
  //   "fColor13": Color.fromRGBO(0, 0, 0, 1),
  //   "fColor14": Color.fromRGBO(255, 255, 255, 1),
  // };

  Widget longPressDialog() {
    return SizedBox(
      height: 266.h,
      child: BlurWidget(Column(
        children: <Widget>[
          PublicCard(
              padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 17.w),
              margin: EdgeInsets.only(
                  left: 36.w, right: 36.w, top: 24.h, bottom: 20.h),
              radius: 90.r,
              widget: Row(
                children: <Widget>[
                  PublicCard(
                      radius: 90.r,
                      height: 50.r,
                      width: 50.r,
                      widget: Container()),
                  SizedBox(width: 17.w),
                  Text(
                    project.projectTtile,
                    style: TextStyle(fontSize: MyFontSize.font18),
                  )
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PublicCard(
                  radius: 90.r, height: 72.r, width: 72.r, widget: Container()),
              SizedBox(width: 24.w),
              PublicCard(
                  radius: 90.r, height: 72.r, width: 72.r, widget: Container()),
            ],
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PublicCard(
        height: 72.h,
        radius: 90.r,
        onLongPress: () {
          Get.bottomSheet(longPressDialog(), barrierColor: Colors.transparent);
        },
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
        widget: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // 头像
                  PublicCard(
                    radius: 90.r,
                    height: 60.r,
                    width: 60.r,
                    widget: Icon(Icons.ac_unit),
                  ),
                  // 计划信息
                  Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          project.projectTtile,
                          style: TextStyle(
                              fontSize: MyFontSize.font18,
                              fontWeight: FontWeight.w600,
                              color: MyColor.fontBlack),
                        ),
                        Text('已加入小组',
                            style: TextStyle(
                                fontSize: MyFontSize.font10,
                                color: MyColor.fontBlack)),
                        Text(
                          project.stageList[0].reminderTime,
                          style: TextStyle(
                              fontSize: MyFontSize.font12,
                              fontWeight: FontWeight.w600,
                              color: MyColor.fontBlack),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Center(
                // 圆形进度条
                child: CircularPercentIndicator(
                  radius: 36.r,
                  lineWidth: 10.r,
                  percent: 0.1,
                  center: Text(
                    "10%",
                    style: TextStyle(
                      fontSize: MyFontSize.font16,
                      color: MyColor.fontBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  startAngle: 270.0,
                  linearGradient: MyWidgetStyle.mainLinearGradient,
                  backgroundColor: const Color.fromRGBO(107, 101, 244, 0.2),
                ),
              )
            ],
          ),
        ));
  }
}
