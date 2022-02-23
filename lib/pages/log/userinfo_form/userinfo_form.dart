import 'dart:io';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import './interest_tag.dart';

// 基础信息
class BasicInfo extends StatefulWidget {
  const BasicInfo({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(top: 11, bottom: 11, left: 24, right: 24),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(107, 101, 244, 1),
                      Color.fromRGBO(51, 84, 244, 1)
                    ])),
            child: Text(
              // 标题
              title,
              style: const TextStyle(
                  color: Color.fromRGBO(240, 242, 243, 1), fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Neumorphic(
            style: const NeumorphicStyle(
                shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
                shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 1),
                depth: -3,
                color: Color.fromRGBO(238, 238, 246, 1),
                // color: Color(0xffEFECF0),
                boxShape: NeumorphicBoxShape.stadium()),
            child: SizedBox(
              height: 44,
              width: 273,
              child: TextFormField(
                onSaved: (value) {
                  saveMethod(value);
                },
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 1)),
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                    hintText: '请输入',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 36, right: 36)),
              ),
            ),
          ),
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
    return Column(children: <Widget>[
      Neumorphic(
        style: const NeumorphicStyle(
            shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
            shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 1),
            depth: -3,
            color: Color.fromRGBO(238, 238, 246, 1),
            // color: Color(0xffEFECF0),
            boxShape: NeumorphicBoxShape.stadium()),
        child: SizedBox(
            height: 88,
            width: 88,
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
      const Text('头像'),
      const SizedBox(height: 68),
      Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              formRow('昵称', (value) {
                print('昵称:$value');
              }),
              formRow('学校', (value) {
                print('学校:$value');
              }),
              formRow('专业', (value) {
                print('专业:$value');
              }),
              formRow('邮箱', (value) {
                print('邮箱:$value');
              }),
            ],
          )),
      // ElevatedButton(
      //     onPressed: () {
      //       print('点击获取');
      //       var _state = _formKey.currentState;
      //       _state!.save();
      //     },
      //     child: const Text('获取'))
    ]);
  }
}

// 兴趣标签选择
class InterestTag extends StatefulWidget {
  const InterestTag({Key? key}) : super(key: key);

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

  refresh(value) {
    print('子组件传值：$value');
    setState(() {
      interest[value]['isSelected'] = !interest[value]['isSelected'];
    });
    // print(interest);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          padding: const EdgeInsets.only(left: 52, right: 52),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              //横轴三个子widget
              mainAxisSpacing: 39,
              crossAxisSpacing: 15,
              childAspectRatio: 2),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: const Text(
            '最多选择三个',
            style: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
          ),
        ),
      ],
    );
  }
}

// 性别选择
class SexSelector extends StatefulWidget {
  const SexSelector({Key? key}) : super(key: key);

  @override
  State<SexSelector> createState() => _SexSelectorState();
}

class _SexSelectorState extends State<SexSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Image.asset('lib/assets/images/male.png'),
        ),
        InkWell(
          onTap: () {},
          child: Image.asset('lib/assets/images/female.png'),
        ),
      ],
    );
  }
}
