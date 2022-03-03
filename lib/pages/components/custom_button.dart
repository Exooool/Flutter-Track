import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final double? height;
  final double? width;
  final double? fontSize;
  final Widget? child;
  final EdgeInsetsGeometry margin;
  final bool shadow;
  const CustomButton(
      {Key? key,
      this.title = '',
      required this.onPressed,
      this.height,
      this.width,
      this.child,
      this.fontSize = 16,
      this.margin = const EdgeInsets.all(20),
      this.shadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: shadow
              ? [
                  const BoxShadow(
                    color: Color.fromRGBO(56, 86, 244, 0.4), // 阴影的颜色
                    offset: Offset(0, 6), // 阴影与容器的距离
                    blurRadius: 10, // 高斯的标准偏差与盒子的形状卷积。
                    spreadRadius: 0, // 在应用模糊之前，框应该膨胀的量。
                  ),
                ]
              : null,
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(107, 101, 244, 1),
                Color.fromRGBO(51, 84, 244, 1)
              ])),
      margin: margin,
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
            // 去除自身的背景色和阴影
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0)),
        child: child ??
            Text(title,
                style: TextStyle(
                    fontSize: fontSize,
                    color: const Color.fromRGBO(240, 242, 243, 1))),
        onPressed: onPressed(),
        // () {
        //   // 调用表单中的onSaved方法
        //   // var state = _formKey.currentState as FormState;
        //   // state.save();
        //   // if (state.validate()) {
        //   //   print("手机号：$_number,密码：$_password");
        //   // }
        //   Navigator.pushNamed(context, '/verify');
        // }
      ),
    );
  }
}
