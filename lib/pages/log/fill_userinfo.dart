import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import './userinfo_form/userinfo_form.dart';

class FillUserInfoPage extends StatefulWidget {
  const FillUserInfoPage({Key? key}) : super(key: key);

  @override
  State<FillUserInfoPage> createState() => _FillUserInfoPageState();
}

class _FillUserInfoPageState extends State<FillUserInfoPage> {
  late List stepList;
  late int stepindex;

  @override
  void initState() {
    super.initState();
    stepList = [
      {'page': const SexSelector(), 'title': '您的性别'},
      {'page': const BasicInfo(), 'title': '基本信息'},
      {'page': const InterestTag(), 'title': '您的兴趣'},
    ];
    stepindex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        'firstUserInfoPage',
        title: stepList[stepindex]['title'],
        leading: InkWell(
          onTap: () {
            setState(() {
              if (stepindex > 0) {
                stepindex -= 1;
              } else if (stepindex == 0) {
                Navigator.pop(context);
              }
            });
          },
          child: const Text('返回'),
        ),
      ),
      body: Stack(
        children: [
          ListView(
              // 使Listview仅包裹内容的高度
              // shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const SizedBox(
                  height: 80,
                  width: 10,
                ),
                stepList[stepindex]['page'],
              ]),
          Positioned(
              bottom: 102.h,
              child: CustomButton(
                title: '下一步',
                height: 60.h,
                width: 300.w,
                fontSize: MyFontSize.font16,
                onPressed: () {
                  // var high = MediaQuery.of(context).viewInsets.bottom;
                  // print('键盘高度$high');
                  print(stepindex);
                  if (stepindex + 1 < stepList.length) {
                    setState(() {
                      stepindex += 1;
                    });
                  }
                },
              ))
        ],
      ),
    );
  }
}
