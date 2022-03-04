import 'package:flutter/material.dart';
import 'package:flutter_track/common/style/my_style.dart';

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
          child: Container(
            height: widget.height,
            width: widget.width,
            padding: widget.headerPadding,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                borderRadius: widget.headerRadius,
                gradient: MyWidgetStyle.mainLinearGradient),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                      color: MyColor.fontWhite,
                      fontSize: MyFontSize.font16,
                      fontWeight: FontWeight.w600),
                ),
                const Icon(
                  Icons.arrow_drop_up,
                  size: 28,
                  color: MyColor.fontWhite,
                )
              ],
            ),
          ),
        ),
        Offstage(
          offstage: closed,
          child: Column(
            children: widget.children,
          ),
        )
      ],
    );
  }
}
