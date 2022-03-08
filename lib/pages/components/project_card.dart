import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard(this.project, {Key? key}) : super(key: key);

  // 颜色对应
  final Map<String, Color> tfColor = const {
    "fColor1": Color.fromRGBO(255, 128, 128, 1),
    "fColor2": Color.fromRGBO(255, 191, 128, 1),
    "fColor3": Color.fromRGBO(255, 255, 128, 1),
    "fColor4": Color.fromRGBO(191, 255, 128, 1),
    "fColor5": Color.fromRGBO(128, 255, 128, 1),
    "fColor6": Color.fromRGBO(128, 255, 191, 1),
    "fColor7": Color.fromRGBO(128, 255, 255, 1),
    "fColor8": Color.fromRGBO(128, 191, 255, 1),
    "fColor9": Color.fromRGBO(128, 128, 255, 1),
    "fColor10": Color.fromRGBO(191, 128, 255, 1),
    "fColor11": Color.fromRGBO(255, 128, 255, 1),
    "fColor12": Color.fromRGBO(255, 128, 191, 1),
    "fColor13": Color.fromRGBO(0, 0, 0, 1),
    "fColor14": Color.fromRGBO(255, 255, 255, 1),
  };

  @override
  Widget build(BuildContext context) {
    return PublicCard(
        height: 72.h,
        radius: 90.r,
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
        widget: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // 头像
                  SizedBox(
                    height: 60.r,
                    width: 60.r,
                    child: CircleAvatar(
                      backgroundColor: tfColor[project.iconInfo.color],
                      child: const Icon(Icons.ac_unit),
                    ),
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
                  progressColor: tfColor[project.iconInfo.color],
                  backgroundColor: const Color.fromRGBO(107, 101, 244, 0.2),
                ),
              )
            ],
          ),
        ));
  }
}
