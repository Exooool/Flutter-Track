import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';

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
                    IconData(0xe667, fontFamily: 'MyIcons'),
                    size: 28,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    IconData(0xe607, fontFamily: 'MyIcons'),
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
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
        // 可以通过设置这个属性防止键盘覆盖内容或者键盘撑起内容
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar('log', title: '登录界面'),
        body: GestureDetector(
          onTap: () {
            print("点击了空白区域");
            _focusNodePassWord.unfocus();
            _focusNodeUserName.unfocus();
          },
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 200,
              ),

              Neumorphic(
                style: const NeumorphicStyle(
                    shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
                    shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 1),
                    depth: -3,
                    color: Color.fromRGBO(238, 238, 246, 1),
                    // color: Color(0xffEFECF0),
                    boxShape: NeumorphicBoxShape.stadium(),
                    lightSource: LightSource.topLeft),
                child: SizedBox(
                  width: 300,
                  height: 56,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 21, right: 10),
                        child: const Center(
                          child: Text(
                            '+86',
                            style: TextStyle(
                                color: Color.fromRGBO(60, 60, 67, 0.6)),
                          ),
                        ),
                      ),
                      Container(
                        height: 38.5,
                        width: 2,
                        color: const Color.fromRGBO(8, 52, 84, 0.15),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 42),
                        width: 198,
                        child: TextFormField(
                          maxLength: 11,
                          focusNode: _focusNodeUserName,
                          decoration: const InputDecoration(
                              // maxLength设置长度后在左下角出现的计时器字符
                              counterText: '',
                              // labelText: '手机',
                              hintText: '请输入手机号',
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(60, 60, 67, 0.6)),
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
                      )
                    ],
                  ),
                ),
              ),
              // 手机与密码输入区域

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
              CustomButton(
                title: '获取验证码',
                onPressed: () {
                  // Navigator.pushNamed(context, '/verify');
                },
              ),
              // 随便逛逛
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      // Navigator.pushReplacementNamed(context, '/home');
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
