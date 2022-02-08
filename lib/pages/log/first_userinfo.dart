import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import './userinfo_form/userinfo_form.dart';

class FirstUserInfoPage extends StatefulWidget {
  const FirstUserInfoPage({Key? key}) : super(key: key);

  @override
  State<FirstUserInfoPage> createState() => _FirstUserInfoPageState();
}

class _FirstUserInfoPageState extends State<FirstUserInfoPage> {
  late List stepList;
  late int stepindex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stepList = [
      {'page': const SexSelector(), 'title': '您的性别'},
      {'page': const InterestTag(), 'title': '您的兴趣'},
      {'page': const BasicInfo(), 'title': '基本信息'}
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
              }
            });
          },
          child: const Text('返回'),
        ),
      ),
      body: Column(children: <Widget>[
        const SizedBox(
          height: 80,
          width: 10,
        ),
        stepList[stepindex]['page'],
        // BasicInfo(),
        CustomButton(
          '下一步',
          onpressed: () {
            print(stepindex);
            if (stepindex + 1 < stepList.length) {
              setState(() {
                stepindex += 1;
              });
            }
          },
        )
      ]),
    );
  }
}
