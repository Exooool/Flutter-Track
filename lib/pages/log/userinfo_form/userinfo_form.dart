import 'dart:io';
import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import './interest_tag.dart';

// 基础信息
class BasicInfo extends StatefulWidget {
  final Map infoJson;
  const BasicInfo(this.infoJson, {Key? key}) : super(key: key);

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  // 表单
  final _formKey = GlobalKey<FormState>();

  // 表单列
  Widget formRow(String title, Function saveMethod) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PublicCard(
              radius: 30.r,
              height: 48.h,
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
              height: 48.h,
              width: 261.w,
              widget: TextFormField(
                onSaved: (value) {
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
  _getImage() async {
    //选择相册
    final pickerImages = await _picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        if (pickerImages != null) {
          image = pickerImages;
          setState(() {});
          print('选择了一张照片');
          print(image?.path);
        } else {
          print('没有照片可以选择');
        }
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
            child: const Text('返回'),
          ),
        ),
        body: Stack(children: <Widget>[
          ListView(
            children: [
              Center(
                child: Neumorphic(
                  style: const NeumorphicStyle(
                      shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
                      shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 1),
                      depth: -3,
                      color: Color.fromRGBO(238, 238, 246, 1),
                      // color: Color(0xffEFECF0),
                      boxShape: NeumorphicBoxShape.stadium()),
                  child: SizedBox(
                      height: 88.r,
                      width: 88.r,
                      child: InkWell(
                        onTap: _getImage,
                        child: image == null
                            ? const SizedBox()
                            : Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                              ),
                      )),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 8.h, bottom: 48.h),
                  child: Text(
                    '头像',
                    style: TextStyle(fontSize: MyFontSize.font16),
                  )),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      formRow('昵称', (value) {
                        print('昵称:$value');
                        widget.infoJson['user_name'] = value;
                      }),
                      formRow('学校', (value) {
                        print('学校:$value');
                        widget.infoJson['school'] = value;
                      }),
                      formRow('专业', (value) {
                        print('专业:$value');
                        widget.infoJson['major'] = value;
                      }),
                      // formRow('邮箱', (value) {
                      //   print('邮箱:$value');
                      // }),
                    ],
                  )),
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
                  _formKey.currentState!.save();
                  Get.to(() => InterestTag(widget.infoJson));
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

  // List interest = [
  //   '校园',
  //   '语言',
  //   '升学',
  //   '心理',
  //   '文学',
  //   '生活',
  //   '运动',
  //   '读书',
  //   '哲学',
  //   '法学',
  //   '经济学',
  //   '艺术学',
  //   '教育学',
  //   '历史学',
  //   '理学',
  //   '工学',
  //   '农学',
  //   '医学',
  //   '管理学',
  //   '其它'
  // ];
  List interestList = [];

  refresh(value) {
    print('子组件传值：$value');

    if (!interestList.contains(value) && interestList.length < 3) {
      interest[value]['isSelected'] = true;
      interestList.add(value);
    } else {
      interest[value]['isSelected'] = false;
      interestList.remove(value);
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
            child: const Text('返回'),
          ),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        fontSize: MyFontSize.font14, color: MyColor.fontGrey),
                  ),
                ),
              ],
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
                  onPressed: () {
                    widget.infoJson['interset'] = interestList;
                    // Get.to(() => const BasicInfo());
                    print(widget.infoJson);
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          'firstUserInfoPage',
          title: '您的性别',
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Text('返回'),
          ),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        sexIndex = 0;
                        setState(() {});
                      },
                      child: Opacity(
                        opacity: sexIndex == 0 ? 1 : 0.5,
                        child: Image.asset('lib/assets/images/male.png'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sexIndex = 1;
                        setState(() {});
                      },
                      child: Opacity(
                        opacity: sexIndex == 1 ? 1 : 0.5,
                        child: Image.asset('lib/assets/images/female.png'),
                      ),
                    ),
                  ],
                ),
              ],
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
                  onPressed: () {
                    var infoJson = {
                      'sex': sexIndex,
                      'img_path': '',
                      'user_name': '',
                      'school': '',
                      'major': '',
                      'interset': []
                    };
                    Get.to(() => BasicInfo(infoJson));
                  },
                ))
          ],
        ));
  }
}
