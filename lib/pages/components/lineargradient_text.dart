import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GradientText extends StatelessWidget {
  final String text;
  const GradientText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16,
          foreground: Paint()
            ..shader = ui.Gradient.linear(
              const Offset(0, 10),
              const Offset(1, 30),
              <Color>[
                const Color.fromRGBO(107, 101, 244, 1),
                const Color.fromRGBO(51, 84, 244, 1)
              ],
            )),
    );
  }
}

var customTextStyle = TextStyle(
    fontSize: 16,
    foreground: Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 10),
        const Offset(1, 30),
        <Color>[
          const Color.fromRGBO(107, 101, 244, 1),
          const Color.fromRGBO(51, 84, 244, 1)
        ],
      ));
