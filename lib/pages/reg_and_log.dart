import 'package:flutter/material.dart';
import 'components/custom_appbar.dart';

class RegPageAndLogPage extends StatefulWidget {
  const RegPageAndLogPage({Key? key}) : super(key: key);

  @override
  _RegPageAndLogPageState createState() => _RegPageAndLogPageState();
}

class _RegPageAndLogPageState extends State<RegPageAndLogPage> {
  //焦点
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassWord = FocusNode();
  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 手机号
  String? _number;
  // 密码
  String? _password;
  // 切换验证码或密码登录
  bool logByPwd = true;

  // 登录按钮
  logButton() {
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
        child: const Text("登录", style: TextStyle(fontSize: 16)),
        onPressed: () {
          // 调用表单中的onSaved方法
          var state = _formKey.currentState as FormState;
          state.save();
          if (state.validate()) {
            print("手机号：$_number,密码：$_password");
          }
        },
      ),
    );
  }

  // 第三方登录
  thirdPartyLog() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(bottom: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                '其他账号登录',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              Container(
                width: 160,
                height: 2,
                color: const Color.fromRGBO(238, 238, 246, 1),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.ac_unit,
                    size: 28,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.ac_unit,
                    size: 28,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.ac_unit,
                    size: 28,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.ac_unit,
                    size: 28,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: createAppbar('log', title: '登录界面'),
        body: GestureDetector(
          onTap: () {
            print("点击了空白区域");
            _focusNodePassWord.unfocus();
            _focusNodeUserName.unfocus();
          },
          child: Column(
            children: <Widget>[
              // 手机与密码输入区域
              Container(
                width: 300,
                margin: const EdgeInsets.only(top: 210, left: 20, right: 20),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 10,
                        spreadRadius: 0,
                        color: Color.fromRGBO(8, 52, 84, 0.05),
                      ),
                      BoxShadow(
                        offset: Offset(-1, -2),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(90),
                    color: const Color.fromRGBO(238, 238, 246, 1)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNodeUserName,
                        decoration: const InputDecoration(

                            // labelText: '手机',
                            // hintText: '请输入手机号',
                            border: InputBorder.none),
                        onSaved: (v) {
                          _number = v;
                        },
                        validator: (v) {
                          if (v!.trim().length < 11) {
                            return "手机号不能小于11位";
                          }
                          return null;
                        },
                      ),
                      // Visibility(
                      //   visible: logByPwd,
                      //   child: TextFormField(
                      //     focusNode: _focusNodePassWord,
                      //     obscureText: true,
                      //     decoration: const InputDecoration(
                      //       labelText: "密码",
                      //       hintText: "请输入密码",
                      //     ),
                      //     onSaved: (v) {
                      //       _password = v;
                      //     },
                      //     validator: (v) {
                      //       if (v!.trim().length < 6) {
                      //         return "密码不能小于11位";
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      // Visibility(
                      //     visible: !logByPwd,
                      //     child: TextFormField(
                      //       decoration: const InputDecoration(
                      //         labelText: "验证码",
                      //         hintText: "请输入验证码",
                      //       ),
                      //     ))
                    ],
                  ),
                ),
              ),
              // 切换密码登录和验证码登录
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     Container(
              //       margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              //       height: 45,
              //       child: ElevatedButton(
              //           onPressed: () {
              //             setState(() {
              //               if (logByPwd) {
              //                 logByPwd = false;
              //               } else {
              //                 logByPwd = true;
              //               }
              //             });
              //           },
              //           child: Text(logByPwd ? '切换验证码登录' : '切换密码登录')),
              //     ),
              //   ],
              // ),
              logButton(),
              // 随便逛逛
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: const Text(
                      '随便逛逛',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(158, 158, 158, 1)),
                    ),
                  )
                ],
              ),
              // 第三方登录
              thirdPartyLog()
            ],
          ),
        ));
  }
}
