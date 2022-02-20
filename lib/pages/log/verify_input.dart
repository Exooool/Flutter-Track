import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
    // TODO: implement initState
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
    // TODO: implement dispose
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

    unFocusedCell = Container(
      child: Text(widget.text),
    );

    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      child: Neumorphic(
          style: NeumorphicStyle(
              shadowDarkColorEmboss: const Color.fromRGBO(8, 52, 84, 0.4),
              shadowLightColorEmboss: const Color.fromRGBO(255, 255, 255, 1),
              depth: -3,
              color: const Color.fromRGBO(238, 238, 246, 1),
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(90))),
          child: Container(
              height: 56,
              width: 40,
              alignment: Alignment.center,
              child: widget.isFocused ? focusedCell : unFocusedCell)),
    );
  }
}
