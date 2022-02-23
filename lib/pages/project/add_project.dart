import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:toggle_switch/toggle_switch.dart';

import '../components/custom_appbar.dart';
import '../components/lineargradient_text.dart';
import 'component/form_datetime_picker.dart';

class AddProject extends StatefulWidget {
  AddProject({Key? key}) : super(key: key);

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  // 表单数据
  var endTime;
  // 分阶段
  int isDivide = 0;
  // 互助小组
  int isJoin = 0;
  // 匹配方式
  int isMacth = 0;

  // 阶段
  var stageList = [
    {},
  ];

  var stageCH = [
    '阶段一',
    '阶段二',
    '阶段三',
    '阶段四',
    '阶段五',
    '阶段六',
    '阶段七',
    '阶段八',
    '阶段九',
    '阶段十'
  ];

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

  // 表单输入框
  Widget formInput(String title, {Widget? component}) {
    return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 6),
        child: Neumorphic(
          style: const NeumorphicStyle(
              shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
              shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 1),
              depth: -3,
              color: Color.fromRGBO(238, 238, 246, 1),
              // color: Color(0xffEFECF0),
              boxShape: NeumorphicBoxShape.stadium()),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            height: 44,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 36),
                Expanded(
                    child: component != null
                        ? Container(
                            alignment: Alignment.centerRight,
                            child: component,
                          )
                        : TextFormField(
                            onSaved: (value) {},
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 0, 0, 1)),
                            textDirection: TextDirection.rtl,
                            decoration: const InputDecoration(
                                hintText: '请输入',
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.2)),
                                hintTextDirection: TextDirection.rtl,
                                border: InputBorder.none)))
              ],
            ),
          ),
        ));
  }

  // 表单开关
  Widget formSwitch(String on, String off, int value, Function onChange) {
    return ToggleSwitch(
      minWidth: on.length == 1 ? 34 : 88,
      fontSize: 16,
      minHeight: 25,
      radiusStyle: true,
      cornerRadius: 60.0,
      inactiveBgColor: Colors.transparent,
      activeFgColor: Colors.white,
      inactiveFgColor: const Color.fromRGBO(0, 0, 0, 0.2),
      activeBgColor: const [
        Color.fromRGBO(107, 101, 244, 1),
        Color.fromRGBO(51, 84, 244, 1)
      ],
      initialLabelIndex: value,
      totalSwitches: 2,
      labels: [on, off],
      onToggle: (index) {
        onChange(index);
        setState(() {});
      },
    );
  }

  Widget columnModel(int stage) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: GradientText(stageCH[stage]),
            ),
            Container(
              padding: const EdgeInsets.only(right: 48),
              alignment: Alignment.centerRight,
              child: stage != 0
                  ? InkWell(
                      onTap: () {
                        stageList.removeAt(stage);
                        setState(() {});
                      },
                      child: const Icon(Icons.close))
                  : null,
            )
          ],
        ),
        formInput('完成内容'),
        formInput('截止时间',
            component: FormDateTimePicker((e) {
              stageList[stage]['endTime'] = e.substring(0, 10);
              setState(() {});
              print(stageList);
            }, stageList[stage]['endTime'])),
        formInput('完成频率',
            component: FormDateTimePicker((e) {
              stageList[stage]['frequency'] = e.substring(11, 16);
              setState(() {});
              print(stageList);
            }, stageList[stage]['frequency'], type: 1)),
        formInput('提醒时间',
            component: FormDateTimePicker((e) {
              stageList[stage]['reminderTime'] = e;
              setState(() {});
              print(stageList);
            }, stageList[stage]['reminderTime'], type: 2)),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'addproject',
        title: '添加计划',
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text('返回',
              style: TextStyle(color: Color.fromRGBO(240, 242, 243, 0.8))),
        ),
        ending: InkWell(
          onTap: () {},
          child: const Text(
            '确定',
            style: TextStyle(color: Color.fromRGBO(240, 242, 243, 0.8)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 109),
        children: <Widget>[
          const SizedBox(height: 15),
          // 头像
          Column(
            children: [
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
              const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text('点击选择头像',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))
            ],
          ),
          // 列表
          formInput('计划名称'),
          formInput('截止时间',
              component: FormDateTimePicker((e) {
                endTime = e;
                setState(() {});
              }, endTime)),
          formInput('分阶段完成',
              component: formSwitch('是', '否', isDivide, (index) {
                isDivide = index;
                print('分阶段完成：$isDivide');
              })),
          // 分阶段
          Visibility(
              visible: isDivide == 0 ? true : false,
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
                      physics: const NeverScrollableScrollPhysics(), //禁止滚动
                      itemCount: stageList.length,
                      itemBuilder: (context, index) {
                        return columnModel(index);
                      }),
                  InkWell(
                    onTap: () {
                      if (stageList.length < 10) {
                        stageList.add({});
                        setState(() {});
                      } else {}
                    },
                    child: Icon(Icons.add),
                  )
                ],
              )),
          formInput('是否加入互助小组',
              component: formSwitch('是', '否', isJoin, (index) {
                isJoin = index;
                print('是否加入互助小组$isJoin');
              })),
          formInput('匹配方式',
              component: formSwitch('系统匹配', '自行邀请', isMacth, (index) {
                isMacth = index;
                print('匹配方式$isMacth');
              })),
        ],
      ),
    );
  }
}
