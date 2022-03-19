import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:get/get.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import '../components/custom_button.dart';
import 'package:jverify/jverify.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 手机号
  late String _number;

  // 切换验证码或密码登录
  bool logByPwd = true;

  // 极光验证
  late String _result = '';
  final Jverify jverify = Jverify();

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
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    jverify.setup(
        appKey: '7c512da646446cc69f9c55a5', channel: "devloper-default");
    jverify.setDebugMode(true); // 是否打开调试模式

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
        body: GestureDetector(
          onTap: () {
            print("点击了空白区域");
            _focusNodePassWord.unfocus();
            _focusNodeUserName.unfocus();
          },
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 68.h, bottom: 42.h),
                  child: Image.asset(
                    'lib/assets/images/logo.png',
                    height: 290.r,
                    width: 290.r,
                  ),
                ),
                PublicCard(
                  height: 60.h,
                  width: 300.w,
                  radius: 30.r,
                  widget: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 21.w, right: 10.w),
                        child: Center(
                          child: Text(
                            '+86',
                            style: TextStyle(
                                fontSize: MyFontSize.font16,
                                foreground: MyFontStyle.textlinearForeground),
                          ),
                        ),
                      ),
                      Container(
                        height: 38.5.h,
                        width: 2.w,
                        decoration: const BoxDecoration(
                            gradient: MyWidgetStyle.mainLinearGradient),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 42.w),
                        width: 198.w,
                        child: TextField(
                          maxLength: 11,
                          focusNode: _focusNodeUserName,
                          // 弹出数字软键盘
                          keyboardType: TextInputType.number,

                          // 限制输入为数字
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              // maxLength设置长度后在左下角出现的计时器字符
                              counterText: '',
                              // labelText: '手机',
                              hintText: '请输入手机号',
                              hintStyle: TextStyle(
                                  fontSize: MyFontSize.font16,
                                  fontWeight: FontWeight.w400,
                                  foreground:
                                      MyFontStyle.textlinearForegroundO5),
                              border: InputBorder.none),
                          onChanged: (value) {
                            _number = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                CustomButton(
                  title: '验证码登录',
                  height: 60.h,
                  width: 300.w,
                  fontSize: MyFontSize.font16,
                  margin: EdgeInsets.only(top: 24.h, bottom: 24.h),
                  onPressed: () async {
                    // 验证手机号码
                    if (GetUtils.isPhoneNumber(_number) &&
                        _number.length == 11) {
                      print(_number);
                      // Get.toNamed('/verify');
                      var url = 'https://api.sms.jpush.cn/v1/codes';
                      var data = {
                        "mobile": _number,
                        "sign_id": "",
                        "temp_id": "1"
                      };
                      Options options = Options(headers: {
                        'authorization':
                            'Basic N2M1MTJkYTY0NjQ0NmNjNjlmOWM1NWE1Ojg4NTI2OWE1NDNlZmVjZTdlMTQ1OGZjZQ==',
                        'content-type': 'application/json'
                      });

                      var res =
                          await Dio().post(url, data: data, options: options);
                      print(res.data);
                      if (res.data['msg_id'] != null) {
                        Get.toNamed('/verify', arguments: {
                          "msg_id": res.data['msg_id'],
                          "mobile": _number
                        });
                        Get.snackbar('提示', '验证码已成功发送');
                      }
                    } else {
                      Get.snackbar('提示', '手机号格式不正确');
                    }
                  },
                ),
                CustomButton(
                  title: '本机号码一键登录',
                  height: 60.h,
                  width: 300.w,
                  fontSize: MyFontSize.font16,
                  margin: const EdgeInsets.all(0),
                  onPressed: () {
                    logAuth();
                  },
                ),
                thirdPartyLog()
              ],
            ),
          ),
        ));
  }

  void logAuth() {
    JVUIConfig uiConfig = JVUIConfig();
    List<JVCustomWidget> widgetList = [];
    // JVPopViewConfig popViewConfig = JVPopViewConfig();
    // popViewConfig.backgroundAlpha = 0;
    // popViewConfig.popViewCornerRadius = 30;
    // popViewConfig.width = 366;
    uiConfig.navHidden = true;
    uiConfig.logoOffsetY = 68.h.toInt();
    uiConfig.logoHeight = 290.r.toInt();
    uiConfig.logoWidth = 290.r.toInt();
    uiConfig.navReturnImgPath = "return";
    // uiConfig.authBackgroundImage = "background";

    // logo
    uiConfig.logoImgPath = "logo";

    // 号码
    uiConfig.numFieldOffsetY = 370.h.toInt();
    uiConfig.numberSize = 30.sp.toInt();
    uiConfig.numberColor = const Color.fromRGBO(107, 101, 244, 1).value;
    uiConfig.numberTextBold = true;

    uiConfig.sloganOffsetY = 412.h.toInt();
    // 隐私
    uiConfig.privacyOffsetY = 34.h.toInt();
    uiConfig.privacyTextSize = 12.sp.toInt();
    uiConfig.privacyState = true;
    uiConfig.privacyCheckboxHidden = true;
    uiConfig.privacyTextCenterGravity = true;
    uiConfig.privacyTextSize = 12.sp.toInt();
    uiConfig.clauseColor = const Color.fromRGBO(107, 101, 244, 1).value;

    //

    // 登录按钮
    uiConfig.logBtnOffsetY = 453.h.toInt();
    uiConfig.logBtnHeight = 60.h.toInt();
    uiConfig.logBtnWidth = 300.w.toInt();
    uiConfig.logBtnBackgroundPath = "log";
    uiConfig.logBtnTextColor = Colors.white.value;
    uiConfig.logBtnTextSize = 16.sp.toInt();

    const String btnWidgetId = "jv_add_custom_button"; // 标识控件 id
    JVCustomWidget buttonWidget =
        JVCustomWidget(btnWidgetId, JVCustomWidgetType.button);

    buttonWidget.title = "切换手机号登录";
    buttonWidget.titleFont = 14.sp;
    buttonWidget.left = 145.w.toInt();
    buttonWidget.top = 537.h.toInt();
    buttonWidget.isShowUnderline = false;
    buttonWidget.titleColor = const Color.fromRGBO(107, 101, 244, 1).value;

    //buttonWidget.btnNormalImageName = "";
    //buttonWidget.btnPressedImageName = "";
    //buttonWidget.textAlignment = JVTextAlignmentType.left;
    // 添加点击事件监听
    uiConfig.needStartAnim = true;
    uiConfig.needStartAnim = true;
    jverify.addClikWidgetEventListener(btnWidgetId, (eventId) {
      jverify.dismissLoginAuthView();
    });
    widgetList.add(buttonWidget);

    jverify.setCustomAuthorizationView(true, uiConfig,
        landscapeConfig: uiConfig, widgets: widgetList);

    jverify.addLoginAuthCallBackListener((event) async {
      setState(() {
        _result = "监听获取返回数据：[${event.code}] message = ${event.message}";
      });
      print(
          "通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
      Get.snackbar('提醒', '${event.code} ${event.message}');
      print('${event.message}');
      var appkey = '7c512da646446cc69f9c55a5';
      var secret = '885269a543efece7e1458fce';
      var basicAuth = 'Basic ' + base64Encode(utf8.encode('$appkey:$secret'));
      print(basicAuth);

      // api请求验证token
      // var respone = await dio.Dio()
      //     .post('https://api.verification.jpush.cn/v1/web/loginTokenVerify',
      //         data: jsonEncode({"loginToken": '${event.message}'}),
      //         options: dio.Options(
      //           headers: {
      //             'authorization': basicAuth,
      //             'content-type': 'application/json'
      //           },
      //         ));
      // Get.snackbar('结果', '$respone');
    });

    /// 再，执行同步的一键登录接口
    jverify.loginAuthSyncApi(autoDismiss: true);
  }
}
