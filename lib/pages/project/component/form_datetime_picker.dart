import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/public_card.dart';

import 'package:get/get.dart';
import './picker_week_row.dart';

class PickerController extends GetxController {
  var repeatText = '每日'.obs;
}

class FormDateTimePicker extends StatelessWidget {
  final Function onChange;
  final String? value;
  // 时间选择器类型 0截止时间 1完成频率 2提醒时间
  final int type;
  final String? beforeEndTime;
  final String? afterEndTime;
  FormDateTimePicker(this.onChange, this.value,
      {Key? key, this.type = 0, this.beforeEndTime, this.afterEndTime})
      : super(key: key);
  final List weekList = ['每周一', '每周二', '每周三', '每周四', '每周五', '每周六', '每周日'];
  final String pickData = '''[["到点提醒","提前5分钟","提前10分钟","提前15分钟","提前20分钟"]]''';
  final PickerController c = Get.put(PickerController());

  Picker customPicker(
      {required PickerAdapter<dynamic> adapter,
      Function(Picker, List<int>)? onConfirm,
      String confirmText = '确定',
      bool hideHeader = false,
      double height = 280,
      Widget? footer}) {
    return Picker(
        adapter: adapter,
        footer: footer,
        hideHeader: hideHeader,
        confirmTextStyle: TextStyle(
            fontSize: MyFontSize.font16,
            foreground: MyFontStyle.textlinearForeground),
        cancelTextStyle: TextStyle(
            fontSize: MyFontSize.font16,
            foreground: MyFontStyle.textlinearForeground),
        confirmText: confirmText,
        cancelText: '取消',
        containerColor: Colors.transparent,
        selectionOverlay: PublicCard(
          radius: 90.r,
          widget: const SizedBox(),
        ),
        backgroundColor: Colors.transparent,
        headerDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        onConfirm: onConfirm);
  }

  // 时间选择器
  showEndTimePicker(BuildContext context) {
    var datetime = DateTime.now();
    // var year = datetime.year;
    // 通过传入的时间限制选择截止时间
    var minTime =
        beforeEndTime == null ? datetime : DateTime.parse(beforeEndTime!);
    var maxTime = afterEndTime == null ? null : DateTime.parse(afterEndTime!);
    Get.bottomSheet(
        SizedBox(
          height: 300.h,
          child: BlurWidget(customPicker(
            adapter: DateTimePickerAdapter(
                maxValue: maxTime,
                minValue: minTime.add(const Duration(days: 1)),
                isNumberMonth: true,
                type: 7),
            onConfirm: (Picker picker, List value) {
              onChange(picker.adapter.text.substring(0, 10));
            },
          ).makePicker()),
        ),
        barrierColor: Colors.transparent);
  }

  // 完成频率选择器
  showFrequencyPicker(BuildContext context) {
    Map<String, dynamic> frequency = {
      'week': [0, 1, 2, 3, 4, 5, 6]
    };

    weekDaySelector() {
      List<int> tempWeek = List.from(frequency['week'] as List);
      Get.bottomSheet(
          SizedBox(
              height: 353.h,
              child: BlurWidget(
                Column(
                  children: <Widget>[
                    customPicker(
                            confirmText: '下一步',
                            onConfirm: (Picker picker, List value) {
                              if (tempWeek.isEmpty) {
                                Get.snackbar('提示', '请选择时间');
                              } else {
                                // 对数组进行排序
                                tempWeek.sort();
                                frequency['week'] = tempWeek;
                                // 将数组转换为字符串显示
                                if (frequency['week'].length == 7) {
                                  c.repeatText.value = '每日';
                                } else {
                                  c.repeatText.value = tempWeek.map((e) {
                                    String temp = '';
                                    return (temp + weekList[e]);
                                  }).toString();
                                }
                                print(c.repeatText.value);
                              }
                            },
                            adapter: PickerDataAdapter())
                        .makePicker(),
                    Expanded(
                        child: ListView.builder(
                      itemCount: weekList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PickerWeekRow(
                            weekList[index], frequency['week']!.contains(index),
                            (e) {
                          // 如果是true就添加
                          if (e) {
                            tempWeek.add(index);
                          } else {
                            tempWeek.remove(index);
                          }

                          print(e);
                          print(frequency);
                          print(tempWeek);
                        });
                      },
                    ))
                  ],
                ),
              )),
          barrierColor: Colors.transparent);
    }

    Get.bottomSheet(
        SizedBox(
          height: 353.h,
          child: BlurWidget(Column(
            children: [
              customPicker(
                  adapter: DateTimePickerAdapter(
                      value: DateTime(2022),
                      maxHour: 24,
                      customColumnType: [3, 4]),
                  onConfirm: (Picker picker, List value) {
                    print(picker.adapter.text.substring(11, 16));
                    frequency['time'] = picker.adapter.text.substring(11, 16);
                    print(frequency);
                    // 传值到外面
                    onChange(frequency);
                  }).makePicker(),
              PublicCard(
                  height: 40.h,
                  radius: 90.r,
                  widget: InkWell(
                      onTap: () {
                        weekDaySelector();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          const Text('重复',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Obx(() => Text(c.repeatText.value,
                              style: const TextStyle(
                                  fontSize: 16, color: MyColor.fontBlackO2)))
                        ],
                      )))
            ],
          )),
        ),
        barrierColor: Colors.transparent);
  }

  showReminderTimePicker(BuildContext context) {
    Get.bottomSheet(
        SizedBox(
          height: 300.h,
          child: BlurWidget(Picker(
                  // confirmTextStyle: customTextStyle,
                  // cancelTextStyle: customTextStyle,
                  confirmText: '确定',
                  cancelText: '取消',
                  backgroundColor: Colors.transparent,
                  onConfirm: (Picker picker, List value) {
                    // 将提醒时间的值传出去
                    onChange(value[0]);
                  },
                  selectionOverlay: PublicCard(
                    radius: 90.r,
                    widget: const SizedBox(),
                  ),
                  confirmTextStyle: TextStyle(
                      fontSize: MyFontSize.font16,
                      foreground: MyFontStyle.textlinearForeground),
                  cancelTextStyle: TextStyle(
                      fontSize: MyFontSize.font16,
                      foreground: MyFontStyle.textlinearForeground),
                  containerColor: Colors.transparent,
                  headerDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  adapter: PickerDataAdapter<String>(
                      pickerdata: const JsonDecoder().convert(pickData),
                      isArray: true))
              .makePicker()),
        ),
        barrierColor: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (type == 1) {
            // 重置文字
            c.repeatText.value = '每日';
            showFrequencyPicker(context);
          } else if (type == 2) {
            showReminderTimePicker(context);
          } else {
            showEndTimePicker(context);
          }
        },
        child: Text(
          value == '' || value == null ? '请选择' : value!,
          textAlign: TextAlign.right,
          style: TextStyle(
              color: MyColor.fontBlackO2, fontSize: MyFontSize.font16),
        ));
  }
}
