import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
import './interest_tag.dart';
import '../components/custom_button.dart';

class FirstUserInfoPage extends StatefulWidget {
  FirstUserInfoPage({Key? key}) : super(key: key);

  @override
  State<FirstUserInfoPage> createState() => _FirstUserInfoPageState();
}

class _FirstUserInfoPageState extends State<FirstUserInfoPage> {
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

  // 兴趣列表
  interstTag() {
    return GridView.builder(
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
    );
  }

  // 基本信息
  basicInfo() {
    return Container(
      child: Text('123'),
    );
  }

  @override
  Widget build(BuildContext context) {
    List pageList = [interstTag(), basicInfo()];
    int pageindex = 0;
    return Scaffold(
      appBar: CustomAppbar(
        'firstUserInfoPage',
        title: '您的性别',
      ),
      body: Column(children: <Widget>[
        const SizedBox(
          height: 80,
        ),
        pageList[pageindex],
        CustomButton(
          '下一步',
          onpressed: () {
            print('123');
          },
        )
      ]),
    );
  }
}
