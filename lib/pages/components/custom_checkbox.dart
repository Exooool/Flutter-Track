import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  bool value;

  Function(bool) onChanged;
  CustomCheckBox({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onChanged(!widget.value);
        },
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 16,
              width: 16,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(107, 101, 244, 1),
                        Color.fromRGBO(51, 84, 244, 1)
                      ])),
              child: Container(
                margin: const EdgeInsets.all(3),
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(60))),
                child: widget.value
                    ? Container(
                        height: 6,
                        width: 6,
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(107, 101, 244, 1),
                                  Color.fromRGBO(51, 84, 244, 1)
                                ])),
                      )
                    : null,
              ),
            )));
  }
}
