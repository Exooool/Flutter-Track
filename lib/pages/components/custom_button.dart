import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  String title;
  var onpressed;
  CustomButton(this.title, {Key? key, this.onpressed}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(56, 86, 244, 0.4), // 阴影的颜色
              offset: Offset(0, 6), // 阴影与容器的距离
              blurRadius: 10, // 高斯的标准偏差与盒子的形状卷积。
              spreadRadius: 0, // 在应用模糊之前，框应该膨胀的量。
            ),
          ],
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(107, 101, 244, 1),
                Color.fromRGBO(51, 84, 244, 1)
              ])),
      margin: const EdgeInsets.all(20),
      width: 300,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
            // 去除自身的背景色和阴影
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0)),
        child: Text(widget.title, style: const TextStyle(fontSize: 16)),
        onPressed: widget.onpressed,
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
