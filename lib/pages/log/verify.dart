import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_track/common/style/my_style.dart';

import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import './verify_input.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';

// 数据存储
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  //验证码
  String _code = '';

  /// 倒计时的计时器。
  late Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds = 60;

  // 当前发送状态
  bool _available = false;

  // 验证码输入框

  verifyInput() {
    List<Widget> list = [];
    for (int i = 1; i <= 6; i++) {
      list.add(VerifyInput(
        isFocused: _code.length == i - 1,
        text: _code.length >= i ? _code.substring(i - 1, i) : '',
      ));
    }
    return list;
  }

  void _setTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _timer.cancel();
        _seconds = 60;
        _available = true;
        setState(() {});
        return;
      }
      _seconds--;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _setTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    // print(arguments);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        'log',
        title: '验证码',
        leading: InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: verifyInput(),
              ),
              Opacity(
                opacity: 0,
                child: TextField(
                  maxLength: 6,
                  autofocus: true,
                  // 弹出数字软键盘
                  keyboardType: TextInputType.number,

                  // 限制输入为数字
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      _code = value;
                    });
                  },
                ),
              ),
            ],
          ),
          CustomButton(
            height: 60.h,
            width: 300.w,
            title: '登录',
            fontSize: MyFontSize.font16,
            onPressed: () async {
              print(_code);
              arguments['code'] = _code;
              print(arguments);

              Get.dialog(Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpinKitFoldingCube(
                      color: Colors.white,
                      size: 50.0,
                    ),
                    SizedBox(height: 10.h),
                    const Text(
                      '加载中',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ));

              DioUtil().verify('/login/messageVerify', data: arguments,
                  success: (res) async {
                print(res);
                Get.back();
                if (res['is_valid']) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('token', res['token']);

                  print('用户登录成功token为：${res['token']}');

                  if (res['first']) {
                    Get.offAllNamed('/sex_info');
                  } else {
                    Get.offAllNamed('/home');
                  }
                } else {
                  Get.back();
                  Get.snackbar('提示', '验证码错误');
                }
              }, error: (error) {
                Get.snackbar('提示', '$error');
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 18.h),
            child: _available
                ? InkWell(
                    onTap: () {
                      _setTimer();
                      _available = false;
                      setState(() {});
                      print('发送验证码');
                    },
                    child: Text('重新发送验证码',
                        style: TextStyle(
                            fontSize: MyFontSize.font14,
                            color: MyColor.fontGrey)),
                  )
                : Text(
                    '重新发送 ${_seconds}s',
                    style: TextStyle(
                        fontSize: MyFontSize.font14, color: MyColor.fontGrey),
                  ),
          ),
        ],
      ),
    );
  }
}
