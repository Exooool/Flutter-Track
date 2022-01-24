import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('账户登录'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            print("点击了空白区域");
            _focusNodePassWord.unfocus();
            _focusNodeUserName.unfocus();
          },
          child: ListView(
            children: <Widget>[
              // 手机与密码输入区域
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNodeUserName,
                        decoration: const InputDecoration(
                          labelText: '手机',
                          hintText: '请输入手机号',
                        ),
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
                      Visibility(
                        visible: logByPwd,
                        child: TextFormField(
                          focusNode: _focusNodePassWord,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "密码",
                            hintText: "请输入密码",
                          ),
                          onSaved: (v) {
                            _password = v;
                          },
                          validator: (v) {
                            if (v!.trim().length < 6) {
                              return "密码不能小于11位";
                            }
                            return null;
                          },
                        ),
                      ),
                      Visibility(
                          visible: !logByPwd,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "验证码",
                              hintText: "请输入验证码",
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              // 切换密码登录和验证码登录
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (logByPwd) {
                              logByPwd = false;
                            } else {
                              logByPwd = true;
                            }
                          });
                        },
                        child: Text(logByPwd ? '切换验证码登录' : '切换密码登录')),
                  ),
                ],
              ),

              // 登录按钮
              Container(
                margin: const EdgeInsets.all(20),
                height: 45,
                child: ElevatedButton(
                  child: const Text("登录"),
                  onPressed: () {
                    // 调用表单中的onSaved方法
                    var state = _formKey.currentState as FormState;
                    state.save();
                    if (state.validate()) {
                      print("手机号：$_number,密码：$_password");
                    }
                  },
                ),
              ),

              // 第三方登录
              Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            // Navigator.pushNamed(context, routeName)
                          },
                          child: const Text(
                            '随便逛逛',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 1.0,
                          color: Colors.grey,
                        ),
                        const Text('第三方登录'),
                        Container(
                          width: 80,
                          height: 1.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          color: Colors.green[200],
                          // 第三方库icon图标
                          icon: Icon(Icons.home),
                          iconSize: 40.0,
                          onPressed: () {},
                        ),
                        IconButton(
                          color: Colors.green[200],
                          icon: Icon(Icons.chat),
                          iconSize: 40.0,
                          onPressed: () {},
                        ),
                        IconButton(
                          color: Colors.green[200],
                          icon: Icon(Icons.phone),
                          iconSize: 40.0,
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
