import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_track/pages/components/lineargradient_text.dart';
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

  FormDateTimePicker(this.onChange, this.value, {Key? key, this.type = 0})
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
        height: height,
        adapter: adapter,
        footer: footer,
        hideHeader: hideHeader,
        confirmTextStyle: customTextStyle,
        cancelTextStyle: customTextStyle,
        confirmText: confirmText,
        cancelText: '取消',
        selectionOverlay: Opacity(
          opacity: 0.1,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromRGBO(107, 101, 244, 1),
                  Color.fromRGBO(51, 84, 244, 1)
                ])),
          ),
        ),
        backgroundColor: const Color.fromRGBO(234, 236, 239, 1),
        headerDecoration: const BoxDecoration(
            color: Color.fromRGBO(234, 236, 239, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        onConfirm: onConfirm);
  }

  // 时间选择器
  showEndTimePicker(BuildContext context) {
    var datetime = DateTime.now();
    var year = datetime.year;
    customPicker(
      adapter:
          DateTimePickerAdapter(isNumberMonth: true, type: 7, yearBegin: year),
      onConfirm: (Picker picker, List value) {
        onChange(picker.adapter.text.substring(0, 10));
      },
    ).showModal(context, backgroundColor: Colors.transparent);
  }

  showFrequencyPicker(BuildContext context) {
    Map<String, dynamic> frequency = {
      'week': [0, 1, 2, 3, 4, 5, 6]
    };

    weekDaySelector() {
      List<int> tempWeek = List.from(frequency['week'] as List);
      customPicker(
              confirmText: '下一步',
              onConfirm: (Picker picker, List value) {
                if (tempWeek.isEmpty) {
                  Fluttertoast.showToast(msg: "请选择时间");
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
          .showModal(context, backgroundColor: Colors.transparent,
              builder: (context, pickerWidget) {
        return SizedBox(
          height: 280,
          child: Column(
            children: <Widget>[
              pickerWidget,
              Expanded(
                  child: Container(
                      color: const Color.fromRGBO(234, 236, 239, 1),
                      child: ListView.builder(
                        itemCount: weekList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PickerWeekRow(weekList[index],
                              frequency['week']!.contains(index), (e) {
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
                      )))
            ],
          ),
        );
      });
    }

    customPicker(
        height: 150,
        footer: Container(
          height: 40,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(234, 236, 239, 1),
              border: Border(
                  top: BorderSide(
                      color: Color.fromRGBO(67, 89, 244, 0.1), width: 0.5),
                  bottom: BorderSide(
                      color: Color.fromRGBO(67, 89, 244, 0.11), width: 0.5))),
          child: InkWell(
              onTap: () {
                weekDaySelector();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text('重复',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Obx(() => Text(c.repeatText.value,
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.2))))
                ],
              )),
        ),
        adapter: DateTimePickerAdapter(
            maxHour: 12, customColumnType: [6, 3, 4], strAMPM: ['上午', '下午']),
        onConfirm: (Picker picker, List value) {
          print(picker.adapter.text.substring(11, 16));
          frequency['time'] = picker.adapter.text.substring(11, 16);
          print(frequency);
          // 传值到外面
          onChange(frequency);
        }).showModal(context, backgroundColor: Colors.transparent);
  }

  showReminderTimePicker(BuildContext context) {
    Picker(
            confirmTextStyle: customTextStyle,
            cancelTextStyle: customTextStyle,
            confirmText: '确定',
            cancelText: '取消',
            backgroundColor: const Color.fromRGBO(234, 236, 239, 1),
            onConfirm: (Picker picker, List value) {
              // 将提醒时间的值传出去
              onChange(value[0]);
            },
            selectionOverlay: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                      Color.fromRGBO(107, 101, 244, 1),
                      Color.fromRGBO(51, 84, 244, 1)
                    ])),
              ),
            ),
            headerDecoration: const BoxDecoration(
                color: Color.fromRGBO(234, 236, 239, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            adapter: PickerDataAdapter<String>(
                pickerdata: const JsonDecoder().convert(pickData),
                isArray: true))
        .showModal(context, backgroundColor: Colors.transparent);
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
          style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.2), fontSize: 16),
        ));
  }
}
