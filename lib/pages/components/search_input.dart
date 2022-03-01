import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final double height;
  final bool gradient;
  final bool enabled;
  final Function onTap;
  final String hintText;
  const SearchInput(
      {Key? key,
      this.height = 24,
      this.gradient = false,
      this.enabled = true,
      this.hintText = '关于如何提高自己的管理能力',
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
      decoration: BoxDecoration(
          gradient: gradient
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                      Color.fromRGBO(107, 101, 244, 1),
                      Color.fromRGBO(51, 84, 244, 1)
                    ])
              : null,
          color: Color.fromRGBO(0, 0, 0, gradient ? 0.2 : 0.05),
          borderRadius: const BorderRadius.all(Radius.circular(60))),
      // 不进行搜索功能 点击后跳转到搜索页
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.search),
          Expanded(
              child: TextField(
            onTap: onTap(),
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration.collapsed(
              // isDense: true,
              enabled: enabled,
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 12),
            ),
          ))
        ],
      ),
    );
  }
}
