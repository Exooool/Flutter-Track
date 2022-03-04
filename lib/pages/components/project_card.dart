import 'package:flutter/material.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
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
    return Container(
      height: 72,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.only(left: 16, right: 32),
      decoration: const BoxDecoration(
          boxShadow: [MyWidgetStyle.mainBoxShadow],
          borderRadius: BorderRadius.all(Radius.circular(60)),
          gradient: MyWidgetStyle.mainLinearGradient),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              // 头像
              CircleAvatar(
                backgroundColor: tfColor[project.iconInfo.color],
                child: const Icon(Icons.ac_unit),
              ),
              // 计划信息
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      project.projectTtile,
                      style: const TextStyle(
                          fontSize: MyFontSize.font18,
                          color: MyColor.fontWhite),
                    ),
                    const Text('(已加入小组)',
                        style: TextStyle(
                            fontSize: MyFontSize.font10,
                            color: MyColor.fontWhiteO5)),
                    Text(
                      project.stageList[0].reminderTime,
                      style: const TextStyle(
                          fontSize: MyFontSize.font12,
                          color: MyColor.fontWhite),
                    )
                  ],
                ),
              )
            ],
          ),
          Center(
            // 圆形进度条
            child: CircularPercentIndicator(
              radius: 18.5,
              lineWidth: 5.0,
              percent: 0.1,
              center: const Text(
                "10%",
                style: TextStyle(
                  fontSize: MyFontSize.font10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              startAngle: 270.0,
              progressColor: tfColor[project.iconInfo.color],
              backgroundColor: const Color.fromRGBO(240, 242, 243, 0.5),
              footer: const Text(
                '剩余270天',
                style: TextStyle(
                    fontSize: MyFontSize.font10,
                    fontWeight: FontWeight.w600,
                    color: MyColor.fontWhite),
              ),
            ),
          )
        ],
      ),
    );
  }
}
