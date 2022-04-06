import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:reorderables/reorderables.dart';

class DragGrid extends StatefulWidget {
  final List dragList;
  final Function() callback;
  const DragGrid({Key? key, required this.dragList, required this.callback})
      : super(key: key);

  @override
  State<DragGrid> createState() => _DragGridState();
}

class _DragGridState extends State<DragGrid> {
  late List<Widget> _tiles;
  late List _copyList;

  List<Widget> getList(List list) {
    List<Widget> l;
    l = list.map((e) {
      return PublicCard(
        radius: 90.r,
        notWhite: true,
        widget: Center(
          child: Text(
            e,
            style: TextStyle(
                color: MyColor.fontWhite,
                fontSize: MyFontSize.font16,
                fontFamily: MyFontFamily.pingfangSemibold),
          ),
        ),
        height: 36.h,
        width: 77.w,
        onTap: () {},
        margin: EdgeInsets.zero,
      );
    }).toList();
    return l;
  }

  @override
  void initState() {
    super.initState();
    _tiles = getList(widget.dragList.sublist(2));
    // 深拷贝
    _copyList = List.from(widget.dragList);
    print(_copyList);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    void _onReorder(int oldIndex, int newIndex) {
      String temp = _copyList.removeAt(oldIndex);
      _copyList.insert(newIndex, temp);

      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
      // print(_tiles);
      print(_copyList);
    }

    var wrap = ReorderableWrap(
        spacing: 15.w,
        runSpacing: 24.h,
        padding: const EdgeInsets.all(8),
        children: _tiles,
        onReorder: _onReorder,
        onNoReorder: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
        },
        onReorderStarted: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
        });

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        wrap,
      ],
    );

    return SingleChildScrollView(
      child: column,
    );
  }
}
