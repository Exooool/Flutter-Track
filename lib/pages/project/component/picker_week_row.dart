import 'package:flutter/material.dart';

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
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
