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
  Widget buildInput() {
    List<Widget> list = [];
    Widget content;
    List inputList = ['昵称', '学校', '专业', '邮箱'];
    for (var item in inputList) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: 11, bottom: 11, left: 24, right: 24),
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
                item,
                style: const TextStyle(
                    color: Color.fromRGBO(240, 242, 243, 1), fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Neumorphic(
              style: const NeumorphicStyle(
                  depth: -2,
                  color: Color.fromRGBO(238, 238, 246, 1),
                  // color: Color(0xffEFECF0),
                  boxShape: NeumorphicBoxShape.stadium()),
              child: SizedBox(
                height: 44,
                width: 273,
                child: TextFormField(
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
      ));
    }
    content = Column(
      children: list,
    );
    return content;
  }

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
    return Column(
      children: <Widget>[
        Neumorphic(
          style: const NeumorphicStyle(
              depth: -2,
              color: Color.fromRGBO(238, 238, 246, 1),
              // color: Color(0xffEFECF0),
              boxShape: NeumorphicBoxShape.stadium()),
          child: SizedBox(
              height: 88,
              width: 88,
              child: InkWell(
                onTap: _getImage,
                child: image == null
                    ? const Icon(Icons.ac_unit)
                    : Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      ),
              )),
        ),
        const Text('头像'),
        const SizedBox(height: 68),
        buildInput()
      ],
    );
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
    '校园',
    '语言',
    '升学',
    '心理',
    '文学',
    '生活',
    '运动',
    '读书',
    '哲学',
    '法学',
    '经济学',
    '艺术学',
    '教育学',
    '历史学',
    '理学',
    '工学',
    '农学',
    '医学',
    '管理学',
    '其它',
  ];

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
            return TagSelector(interest[index]);
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
        )
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
