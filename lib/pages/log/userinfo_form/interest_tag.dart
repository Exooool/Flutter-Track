import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';

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
          // 传出index 改变当前的选择状态
          widget.changeValue(widget.index);
          setState(() {});
        },
        child: Center(
          child: widget.isSelected
              ? PublicCard(
                  height: 36.h,
                  width: 77.w,
                  radius: 30.r,
                  notWhite: true,
                  widget: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: MyFontSize.font16,
                          fontWeight: FontWeight.w600,
                          color: MyColor.fontWhite),
                    ),
                  ),
                )
              : Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: MyFontSize.font16,
                      fontWeight: FontWeight.w600,
                      color: MyColor.fontBlack),
                ),
        ));
  }
}
