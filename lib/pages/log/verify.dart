import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import './verify_input.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';

class VerifyPage extends StatefulWidget {
  VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  //验证码
  String _code = '';

  // 验证码输入框

  verifyInput() {
    List<Widget> list = [];
    for (int i = 1; i <= 4; i++) {
      list.add(VerifyInput(
        isFocused: _code.length == i - 1,
        text: _code.length >= i ? _code.substring(i - 1, i) : '',
      ));
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  maxLength: 4,
                  autofocus: true,
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
            '登录',
            onPressed: () {
              print(_code);
              Navigator.pushReplacementNamed(context, '/fill_userinfo');
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
            child: const Text(
              '重新发送 60s',
              style: TextStyle(
                  fontSize: 14, color: Color.fromRGBO(158, 158, 158, 1)),
            ),
          )
        ],
      ),
    );
  }
}
