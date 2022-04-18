import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_track/common/style/my_style.dart';

import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/custom_dialog.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './interest_tag.dart';
import 'package:dio/dio.dart' as dio;

// 基础信息
class BasicInfo extends StatefulWidget {
  final Map infoJson;
  const BasicInfo(this.infoJson, {Key? key}) : super(key: key);

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final ImagePicker _picker = ImagePicker();
  late String name = '';
  late String college = '';
  late String major = '';
  late String imgUrl = '';

  // 表单列
  Widget formRow(String title, Function saveMethod) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PublicCard(
              radius: 30.r,
              padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
              width: 81.w,
              notWhite: true,
              widget: Center(
                child: Text(
                  // 标题
                  title,
                  style: TextStyle(
                      color: MyColor.white, fontSize: MyFontSize.font16),
                ),
              )),
          const SizedBox(width: 12),
          PublicCard(
              radius: 30.r,
              width: 261.w,
              padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
              widget: TextField(
                onChanged: (value) {
                  saveMethod(value);
                },
                style: TextStyle(
                    fontSize: MyFontSize.font16,
                    fontWeight: FontWeight.w500,
                    color: MyColor.fontBlack),
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                    hintText: '请输入',
                    hintTextDirection: TextDirection.rtl,
                    isCollapsed: true,
                    hintStyle: TextStyle(
                        fontSize: MyFontSize.font16,
                        fontWeight: FontWeight.w500,
                        color: MyColor.fontBlackO2),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 36.w, right: 36.w)),
              )),
        ],
      ),
    );
  }

  // 获取照片

  Future pickImage() async {
    final file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 65);

    if (file != null) {
      dio.FormData formdata = dio.FormData.fromMap({
        "image":
            await dio.MultipartFile.fromFile(file.path, filename: file.name)
      });

      DioUtil().post('/article/imgPost', data: formdata, success: (res) {
        print(res);
        setState(() {
          imgUrl = DioUtil.imgBaseUrl + '/' + res.toString();
        });
      }, error: (error) {
        print(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          'firstUserInfoPage',
          title: '基本信息',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
          ending: InkWell(
            onTap: () {
              Get.to(() => InterestTag(widget.infoJson));
            },
            child: Text(
              '跳过',
              style: TextStyle(
                  color: MyColor.fontBlack,
                  fontFamily: MyFontFamily.pingfangSemibold,
                  fontSize: MyFontSize.font14),
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          ListView(
            children: [
              SizedBox(height: 30.h),
              Center(
                child: SizedBox(
                    height: 88.r,
                    width: 88.r,
                    child: InkWell(
                      onTap: pickImage,
                      child: imgUrl == ''
                          ? Image.asset('lib/assets/images/defaultUserImg.png')
                          : ClipOval(
                              child: Image.network(
                                imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                    )),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 8.h, bottom: 48.h),
                  child: Text(
                    '头像',
                    style: TextStyle(
                        fontSize: MyFontSize.font16,
                        fontFamily: MyFontFamily.pingfangMedium),
                  )),
              Column(
                children: <Widget>[
                  formRow('昵称', (value) {
                    print('昵称:$value');
                    name = value;
                  }),
                  formRow('学校', (value) {
                    print('学校:$value');
                    college = value;
                  }),
                  formRow('专业', (value) {
                    print('专业:$value');
                    major = value;
                  }),
                  // formRow('邮箱', (value) {
                  //   print('邮箱:$value');
                  // }),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 102.h,
              left: (MediaQueryData.fromWindow(window).size.width - 300.w) / 2,
              child: CustomButton(
                title: '下一步',
                height: 60.h,
                width: 300.w,
                margin: EdgeInsets.zero,
                fontSize: MyFontSize.font16,
                onPressed: () {
                  // 执行表单的save操作
                  if (name == '' ||
                      major == '' ||
                      college == '' ||
                      imgUrl == '') {
                    Get.snackbar('提示', '请填入信息');
                  } else {
                    widget.infoJson['user_name'] = name;
                    widget.infoJson['college'] = college;
                    widget.infoJson['major'] = major;
                    widget.infoJson['user_img'] = imgUrl;
                    Get.to(() => InterestTag(widget.infoJson));
                  }
                },
              ))
        ]));
  }
}

// 兴趣标签选择
class InterestTag extends StatefulWidget {
  final Map infoJson;
  const InterestTag(this.infoJson, {Key? key}) : super(key: key);

  @override
  State<InterestTag> createState() => _InterestTagState();
}

class _InterestTagState extends State<InterestTag> {
  List interest = [
    {'name': '校园', 'isSelected': false},
    {'name': '语言', 'isSelected': false},
    {'name': '升学', 'isSelected': false},
    {'name': '心理', 'isSelected': false},
    {'name': '文学', 'isSelected': false},
    {'name': '生活', 'isSelected': false},
    {'name': '运动', 'isSelected': false},
    {'name': '读书', 'isSelected': false},
    {'name': '哲学', 'isSelected': false},
    {'name': '法学', 'isSelected': false},
    {'name': '经济学', 'isSelected': false},
    {'name': '艺术学', 'isSelected': false},
    {'name': '教育学', 'isSelected': false},
    {'name': '历史学', 'isSelected': false},
    {'name': '理学', 'isSelected': false},
    {'name': '工学', 'isSelected': false},
    {'name': '农学', 'isSelected': false},
    {'name': '医学', 'isSelected': false},
    {'name': '管理学', 'isSelected': false},
    {'name': '其它', 'isSelected': false},
  ];

  List<String> interestList = [];

  refresh(value) {
    print('子组件传值：$value');

    if (!interestList.contains(interest[value]['name']) &&
        interestList.length < 3) {
      interest[value]['isSelected'] = true;
      interestList.add(interest[value]['name']);
    } else {
      interest[value]['isSelected'] = false;
      interestList.remove(interest[value]['name']);
    }
    setState(() {});
    // print(interest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          'firstUserInfoPage',
          title: '您的兴趣',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
          ending: InkWell(
            onTap: () {
              Get.dialog(
                CustomDialog(
                  height: 330.h,
                  width: 318.w,
                  title: '提示',
                  content: '您确定要跳过填写信息吗！',
                  subContent: '在个人主页也可以进行修改个人信息！',
                  onCancel: () {
                    Get.back();
                  },
                  onConfirm: () {
                    Get.offAllNamed('/home');
                  },
                ),
                barrierColor: Colors.transparent,
              );
            },
            child: Text(
              '跳过',
              style: TextStyle(
                  color: MyColor.fontBlack,
                  fontFamily: MyFontFamily.pingfangSemibold,
                  fontSize: MyFontSize.font14),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 130.h),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GridView.builder(
                    //解决无限高度问题
                    shrinkWrap: true,
                    //禁用滑动事件
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: interest.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TagSelector(
                        interest[index]['name'],
                        index,
                        isSelected: interest[index]['isSelected'],
                        changeValue: (e) {
                          refresh(e);
                        },
                      );
                    },
                    padding: EdgeInsets.only(left: 52.w, right: 52.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        //横轴三个子widget
                        mainAxisSpacing: 39.h,
                        crossAxisSpacing: 15.w,
                        childAspectRatio: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.h),
                    child: Text(
                      '最多选择三个',
                      style: TextStyle(
                          fontFamily: MyFontFamily.pingfangMedium,
                          fontSize: MyFontSize.font14,
                          color: MyColor.fontGrey),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 102.h,
                left:
                    (MediaQueryData.fromWindow(window).size.width - 300.w) / 2,
                child: CustomButton(
                  title: '下一步',
                  height: 60.h,
                  width: 300.w,
                  margin: EdgeInsets.zero,
                  fontSize: MyFontSize.font16,
                  onPressed: () async {
                    // print(interestList);
                    if (interestList.length == 3) {
                      widget.infoJson['interset'] = interestList;
                      // Get.to(() => const BasicInfo());

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      prefs.setStringList('interest', interestList);
                      print(widget.infoJson);

                      // 请求端口修改数据

                      DioUtil().post('/users/update', data: widget.infoJson,
                          success: (res) {
                        if (res['status'] == 0) {
                          print('修改成功');
                          Get.offAllNamed('/home');
                        } else {
                          print('修改失败');
                          Get.snackbar('提示', '网络错误');
                        }
                      }, error: (error) {
                        print(error);
                      });
                    } else {
                      Get.snackbar('提示', '请选择你感兴趣的标签');
                    }
                  },
                ))
          ],
        ));
  }
}

// 性别选择
class SexSelector extends StatefulWidget {
  const SexSelector({Key? key}) : super(key: key);

  @override
  State<SexSelector> createState() => _SexSelectorState();
}

class _SexSelectorState extends State<SexSelector> {
  late int sexIndex = 0;

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
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          'firstUserInfoPage',
          title: '您的性别',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
          ending: InkWell(
            onTap: () {
              var infoJson = {
                'sex': sexIndex == 0 ? '男' : '女',
                'user_img': '',
                'user_name': '',
                'college': '',
                'major': '',
                'interset': []
              };
              Get.to(() => BasicInfo(infoJson));
            },
            child: Text(
              '跳过',
              style: TextStyle(
                  color: MyColor.fontBlack,
                  fontFamily: MyFontFamily.pingfangSemibold,
                  fontSize: MyFontSize.font14),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 160.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      sexIndex = 0;
                      setState(() {});
                    },
                    child: Opacity(
                        opacity: sexIndex == 0 ? 1 : 0.5,
                        child: Column(
                          children: [
                            Image.asset('lib/assets/images/male.png',
                                width: MediaQueryData.fromWindow(window)
                                        .size
                                        .width /
                                    2),
                            Text('男生',
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    fontFamily: MyFontFamily.pingfangMedium))
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      sexIndex = 1;
                      setState(() {});
                    },
                    child: Opacity(
                        opacity: sexIndex == 1 ? 1 : 0.5,
                        child: Column(
                          children: [
                            Image.asset('lib/assets/images/female.png',
                                width: MediaQueryData.fromWindow(window)
                                        .size
                                        .width /
                                    2),
                            Text('女生',
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    fontFamily: MyFontFamily.pingfangMedium))
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 102.h,
                left:
                    (MediaQueryData.fromWindow(window).size.width - 300.w) / 2,
                child: PublicCard(
                  radius: 90.r,
                  notWhite: true,
                  widget: Center(
                    child: Text(
                      '下一步',
                      style: TextStyle(
                          fontSize: MyFontSize.font16,
                          color: MyColor.white,
                          fontFamily: MyFontFamily.pingfangMedium),
                    ),
                  ),
                  width: 300.w,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(top: 19.h, bottom: 19.h),
                  onTap: () async {
                    var infoJson = {
                      'sex': sexIndex == 0 ? '男' : '女',
                      'user_img': '',
                      'user_name': '',
                      'college': '',
                      'major': '',
                      'interset': []
                    };
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    print("登录token为：${prefs.getString('token')}");
                    Get.to(() => BasicInfo(infoJson));
                  },
                ))
          ],
        ));
  }
}
