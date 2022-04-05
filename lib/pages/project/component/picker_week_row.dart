import 'package:flutter/material.dart';
import 'package:flutter_track/common/style/my_style.dart';

import '../../components/custom_checkbox.dart';

class PickerWeekRow extends StatefulWidget {
  final String text;
  final Function onSelected;
  bool value = false;
  PickerWeekRow(this.text, this.value, this.onSelected, {Key? key})
      : super(key: key);

  @override
  State<PickerWeekRow> createState() => _PickerWeekRowState();
}

class _PickerWeekRowState extends State<PickerWeekRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 70, right: 85, top: 6, bottom: 6),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(67, 89, 244, 0.1), width: 0.5),
                bottom: BorderSide(
                    color: Color.fromRGBO(67, 89, 244, 0.11), width: 0.5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                  fontFamily: MyFontFamily.pingfangMedium, fontSize: 16),
            ),
            CustomCheckBox(
                value: widget.value,
                onChanged: (e) {
                  // print(e);
                  widget.value = e;
                  widget.onSelected(e);
                  setState(() {});
                })
          ],
        ));
  }
}
