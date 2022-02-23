import 'package:flutter/material.dart';

class PickerWeekRow extends StatefulWidget {
  final String text;
  final Function onSelected;

  PickerWeekRow(this.text, this.onSelected, {Key? key}) : super(key: key);

  @override
  State<PickerWeekRow> createState() => _PickerWeekRowState();
}

class _PickerWeekRowState extends State<PickerWeekRow> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(67, 89, 244, 0.1), width: 0.5),
                bottom: BorderSide(
                    color: Color.fromRGBO(67, 89, 244, 0.11), width: 0.5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.text),
            Checkbox(
                value: value,
                onChanged: (e) {
                  value = e!;
                  widget.onSelected(e);
                  setState(() {});
                })
          ],
        ));
  }
}
