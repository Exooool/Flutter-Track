import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';

class ExpansionList extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? headerPadding;
  final BorderRadiusGeometry? headerRadius;
  final EdgeInsetsGeometry? childrenPadding;
  final double? height;
  final double? width;

  const ExpansionList(
      {Key? key,
      required this.title,
      this.children = const <Widget>[],
      this.headerPadding,
      this.headerRadius,
      this.childrenPadding,
      this.height,
      this.width})
      : super(key: key);

  @override
  State<ExpansionList> createState() => _ExpansionListState();
}

class _ExpansionListState extends State<ExpansionList> {
  bool closed = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // header
        InkWell(
          onTap: () {
            closed = !closed;
            setState(() {});
          },
          child: PublicCard(
            radius: 90.r,
            height: widget.height,
            width: widget.width,
            padding: widget.headerPadding,
            margin: EdgeInsets.only(bottom: 12.h),
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      color: MyColor.fontBlack,
                      fontSize: MyFontSize.font16,
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 28.sp,
                  color: MyColor.fontBlack,
                )
              ],
            ),
          ),
        ),
        Offstage(
          offstage: closed,
          child: ListView(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            shrinkWrap: true,
            children: widget.children,
          ),
        )
      ],
    );
  }
}
