import 'dart:convert';

import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/log/beforelog.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jverify/jverify.dart';

class RegPageAndLogPage extends StatefulWidget {
  const RegPageAndLogPage({Key? key}) : super(key: key);

  @override
  _RegPageAndLogPageState createState() => _RegPageAndLogPageState();
}

class _RegPageAndLogPageState extends State<RegPageAndLogPage>
    with TickerProviderStateMixin {
  // 动画控制
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  //焦点
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassWord = FocusNode();
  //表单状态

  // 手机号
  late String _number = '';

  // 切换验证码或密码登录
  bool logByPwd = true;

  // 极光验证
  late String _result = '';
  final Jverify jverify = Jverify();

  not() {
    Get.snackbar('提示', '第三方登录暂未开通');
  }

  // 第三方登录
  thirdPartyLog() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(bottom: 64.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 18.h,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '其他账号登录',
                style: TextStyle(
                    fontSize: MyFontSize.font12,
                    color: MyColor.fontGrey,
                    fontFamily: MyFontFamily.pingfangRegular),
              ),
              SizedBox(height: 12.h),
              Container(
                width: 160.w,
                height: 1.h,
                color: MyColor.fontGrey,
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: not,
                  child: Image.asset(
                    'lib/assets/images/抖音.png',
                    height: 28.r,
                    width: 28.r,
                  ),
                ),
                SizedBox(width: 14.w),
                InkWell(
                  onTap: not,
                  child: Image.asset(
                    'lib/assets/images/apple.png',
                    height: 28.r,
                    width: 28.r,
                  ),
                ),
                SizedBox(width: 14.w),
                InkWell(
                  onTap: not,
                  child: Image.asset(
                    'lib/assets/images/微信.png',
                    height: 28.r,
                    width: 28.r,
                  ),
                ),
                SizedBox(width: 14.w),
                InkWell(
                  onTap: not,
                  child: Image.asset(
                    'lib/assets/images/QQ.png',
                    height: 28.r,
                    width: 28.r,
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
    // controller =
    //     AnimationController(duration: const Duration(seconds: 12), vsync: this)
    //       ..addListener(() {
    //         setState(() {});
    //       });

    // opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
    //     CurvedAnimation(parent: controller, curve: const Interval(1 / 2, 1)));
    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    jverify.setup(
        appKey: '7c512da646446cc69f9c55a5', channel: "devloper-default");
    jverify.setDebugMode(false); // 是否打开调试模式

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
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 60.h,
                      ),
                      child: Image.asset(
                        'lib/assets/images/logo.png',
                        height: 355.r,
                        width: 355.r,
                      ),
                    ),
                    PublicCard(
                      padding: EdgeInsets.only(bottom: 5.h),
                      width: 300.w,
                      radius: 90.r,
                      widget: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 21.w, right: 10.w),
                            child: Center(
                              child: Text(
                                '+86',
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    fontFamily: MyFontFamily.sfDisplayRegular,
                                    foreground:
                                        MyFontStyle.textlinearForegroundO2),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.2,
                            child: Container(
                              height: 38.5.h,
                              width: 2.w,
                              decoration: const BoxDecoration(
                                  gradient: MyWidgetStyle.mainLinearGradient),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 35.w),
                            width: 198.w,
                            child: TextField(
                              maxLength: 11,
                              focusNode: _focusNodeUserName,
                              // 弹出数字软键盘
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: MyFontSize.font16,
                                  fontFamily: MyFontFamily.pingfangRegular,
                                  foreground: MyFontStyle.textlinearForeground),

                              // 限制输入为数字
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  // maxLength设置长度后在左下角出现的计时器字符
                                  counterText: '',
                                  // labelText: '手机',
                                  hintText: '请输入手机号码',
                                  hintStyle: TextStyle(
                                      fontSize: MyFontSize.font16,
                                      fontFamily: MyFontFamily.pingfangRegular,
                                      foreground:
                                          MyFontStyle.textlinearForegroundO2),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                _number = value;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    PublicCard(
                      radius: 90.r,
                      width: 300.w,
                      notWhite: true,
                      padding: EdgeInsets.only(top: 19.h, bottom: 19.h),
                      margin: EdgeInsets.only(top: 24.h, bottom: 24.h),
                      widget: Center(
                        child: Text(
                          '获取验证码',
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              color: MyColor.white,
                              fontFamily: MyFontFamily.pingfangSemibold),
                        ),
                      ),
                      onTap: () async {
                        // 验证手机号码
                        if (GetUtils.isPhoneNumber(_number) &&
                            _number.length == 11) {
                          print(_number);

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

                          // 集成极光API的多个参数
                          var data = {
                            "mobile": _number,
                            "sign_id": "",
                            "temp_id": "1"
                          };
                          // 访问极光API 获取手机验证码
                          DioUtil().logPost('https://api.sms.jpush.cn/v1/codes',
                              data: data, success: (res) {
                            print(res);
                            Get.back();
                            if (res['msg_id'] != null) {
                              Get.toNamed('/verify', arguments: {
                                "msg_id": res['msg_id'],
                                "mobile": _number
                              });
                              Get.snackbar('提示', '验证码已成功发送');
                            } else {
                              Get.snackbar('提示', '验证码发送失败');
                            }
                          }, error: (error) {
                            Get.back();
                            Get.snackbar('提示', '$error');
                          });
                        } else {
                          Get.snackbar('提示', '手机号格式不正确');
                        }
                      },
                    ),
                    PublicCard(
                      radius: 90.r,
                      width: 300.w,
                      notWhite: true,
                      padding: EdgeInsets.only(top: 19.h, bottom: 19.h),
                      margin: const EdgeInsets.all(0),
                      widget: Center(
                        child: Text(
                          '本机号码一键登录',
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              color: MyColor.white,
                              fontFamily: MyFontFamily.pingfangSemibold),
                        ),
                      ),
                      onTap: () {
                        logAuth();
                      },
                    ),
                    thirdPartyLog(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 34.h),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: MyFontSize.font12,
                                  fontFamily: MyFontFamily.pingfangRegular,
                                  color: MyColor.fontGrey),
                              children: [
                            const TextSpan(text: '登录即同意'),
                            TextSpan(
                                text: '《注册协议》',
                                style: TextStyle(
                                    foreground:
                                        MyFontStyle.textlinearForeground)),
                            const TextSpan(text: '以及'),
                            TextSpan(
                                text: '《隐私政策》',
                                style: TextStyle(
                                    foreground:
                                        MyFontStyle.textlinearForeground))
                          ])),
                    )
                  ],
                ),
              ),
              // Container(
              //   child: Image.asset(
              //     'lib/assets/gifs/开屏.gif',
              //     width: double.infinity,
              //   ),
              // )
              BeforeLog()
            ],
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
      // Get.snackbar('提醒', '${event.code} ${event.message}');
      print('${event.message}');
      var appkey = '7c512da646446cc69f9c55a5';
      var secret = '885269a543efece7e1458fce';
      var basicAuth = 'Basic ' + base64Encode(utf8.encode('$appkey:$secret'));
      print(basicAuth);

      if (event.code == 6000) {
        DioUtil().verify('/login/loginTokenVerify',
            data: {'loginToken': event.message}, success: (res) async {
          print(res);
          if (res['is_valid']) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', res['token']);

            print('用户登录成功token为：${res['token']}');

            if (res['first']) {
              Get.offAllNamed('/sex_info');
            } else {
              Get.offAllNamed('/home');
            }
          } else {
            Get.snackbar('提示', '一键登录错误，请重试');
          }
        }, error: (error) {
          Get.snackbar('提示', '$error');
        });
      } else {
        Get.snackbar('提示', '一键登录失败，请检查网络问题，不要连接wifi热点进行登录');
      }

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
