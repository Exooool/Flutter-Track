import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  String title;
  bool isSelected;
  int index;
  Function changeValue;
  TagSelector(this.title, this.index,
      {Key? key, this.isSelected = false, required this.changeValue})
      : super(key: key);

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // widget.isSelected = !widget.isSelected;
          // var value = {'index': widget.index, 'isSelected': widget.isSelected};
          // 传出index 改变当前抱歉的选择状态
          widget.changeValue(widget.index);
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          // margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: widget.isSelected
                      ? const [
                          Color.fromRGBO(107, 101, 244, 1),
                          Color.fromRGBO(51, 84, 244, 1)
                        ]
                      : [Colors.transparent, Colors.transparent])),
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.isSelected
                    ? const Color.fromRGBO(240, 242, 243, 1)
                    : const Color.fromRGBO(0, 0, 0, 1)),
          ),
        ));
  }
}
