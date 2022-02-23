import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_track/pages/components/lineargradient_text.dart';

import './picker_week_row.dart';

class FormDateTimePicker extends StatefulWidget {
  final Function onChange;
  final String? value;
  // 时间选择器类型 0年月日 1时段小时分钟 2自定义时间
  final int type;

  const FormDateTimePicker(this.onChange, this.value, {Key? key, this.type = 0})
      : super(key: key);

  @override
  State<FormDateTimePicker> createState() => _FormDateTimePickerState();
}

class _FormDateTimePickerState extends State<FormDateTimePicker> {
  List weekList = [
    {'day': '每周一', 'isSelect': false},
    {'day': '每周二', 'isSelect': false},
    {'day': '每周三', 'isSelect': false},
    {'day': '每周四', 'isSelect': false},
    {'day': '每周五', 'isSelect': false},
    {'day': '每周六', 'isSelect': false},
    {'day': '每周日', 'isSelect': false}
  ];
  String pickData = '''[["到点提醒","提前5分钟","提前10分钟","提前15分钟","提前20分钟"]]''';
  // 时间选择器
  showPickerModal(BuildContext context) {
    var datetime = DateTime.now();
    var year = datetime.year;
    Picker(
        height: 280,
        adapter: DateTimePickerAdapter(
            isNumberMonth: true,
            type: 7,
            yearBegin: year,
            maxHour: 12,
            customColumnType: widget.type == 1 ? [6, 3, 4] : null,
            strAMPM: ['上午', '下午']),
        hideHeader: false,
        confirmTextStyle: customTextStyle,
        cancelTextStyle: customTextStyle,
        confirmText: '确定',
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
        onConfirm: (Picker picker, List value) {
          // print(value.toString());
          print(picker.adapter.text);
          // 截断
          widget.onChange(picker.adapter.text);
        }).showModal(context, backgroundColor: Colors.transparent);
  }

  showPickerArray(BuildContext context) {
    // Picker(
    //     adapter: PickerDataAdapter<String>(
    //         pickerdata: const JsonDecoder().convert(pickData), isArray: true));

    Picker(
      adapter: PickerDataAdapter(),
      headerDecoration: const BoxDecoration(
          color: Color.fromRGBO(234, 236, 239, 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    ).showModal(context, backgroundColor: Colors.transparent,
        builder: (context, pickerWidget) {
      return SizedBox(
        height: 280,
        child: Column(
          children: <Widget>[
            pickerWidget,
            Expanded(
                child: Container(
                    color: const Color.fromRGBO(234, 236, 239, 1),
                    child: ListView(
                      children: [
                        PickerWeekRow(weekList[0]['day'], (e) {
                          weekList[0]['isSelect'] = e;
                          print(e);
                          print(weekList);
                        })
                      ],
                    )))
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.type == 2) {
            showPickerArray(context);
          } else {
            showPickerModal(context);
          }
        },
        child: Text(
          widget.value ?? '请选择',
          textAlign: TextAlign.right,
          style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.2), fontSize: 16),
        ));
  }
}
