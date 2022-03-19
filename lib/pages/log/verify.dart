import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/config/http_config.dart';
import 'package:get/get.dart';
import './verify_input.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  //验证码
  String _code = '';

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

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    print(arguments);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar('log', title: '验证码'),
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
              var res = await Dio().post(
                HttpOptions.BASE_URL + '/login/messageVerify',
                data: arguments,
              );
              print(res.data);
              // Get.toNamed('/sex_info');
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 18.h),
            child: Text(
              '重新发送 60s',
              style: TextStyle(
                  fontSize: MyFontSize.font14,
                  color: const Color.fromRGBO(158, 158, 158, 1)),
            ),
          )
        ],
      ),
    );
  }
}
