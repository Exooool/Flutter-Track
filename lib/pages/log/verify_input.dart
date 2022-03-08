import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';

class VerifyInput extends StatefulWidget {
  final bool isFocused;
  final String text;
  const VerifyInput({Key? key, this.isFocused = false, this.text = ''})
      : super(key: key);

  @override
  State<VerifyInput> createState() => _VerifyInputState();
}

class _VerifyInputState extends State<VerifyInput> {
  late Timer timer;
  List<Color> cursorColor = const [
    Color.fromRGBO(107, 101, 244, 1),
    Color.fromRGBO(51, 84, 244, 1)
  ];

  var unFocusedCell;
  var focusedCell;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        cursorColor = [Colors.transparent, Colors.transparent];
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) {
          return;
        }
        setState(() {
          cursorColor = const [
            Color.fromRGBO(107, 101, 244, 1),
            Color.fromRGBO(51, 84, 244, 1)
          ];
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    focusedCell = Container(
      height: 20,
      width: 3,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: cursorColor)),
    );

    unFocusedCell = Text(
      widget.text,
      style: TextStyle(
          fontSize: MyFontSize.font30,
          foreground: MyFontStyle.textlinearForeground),
    );

    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      child: PublicCard(
          height: 60.h,
          width: 40.w,
          radius: 30.r,
          widget: Container(
              alignment: Alignment.center,
              child: widget.isFocused ? focusedCell : unFocusedCell)),
    );
  }
}
