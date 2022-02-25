import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../components/lineargradient_text.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'component/form_datetime_picker.dart';

import '../components/custom_appbar.dart';

import 'add_project_controller.dart';

class AddProject extends StatelessWidget {
  AddProject({Key? key}) : super(key: key);
  final AddProjectController c = Get.put(AddProjectController());

  // 表单输入框
  Widget formInput(String title, {Widget? component, Function? onChanged}) {
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
                            onChanged: (value) {
                              onChanged!(value);
                            },
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
      },
    );
  }

  // 分阶段模板
  Widget columnModel(int stage) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: GradientText(c.stageCH[stage]),
            ),
            Container(
              padding: const EdgeInsets.only(right: 48),
              alignment: Alignment.centerRight,
              child: stage != 0
                  ? InkWell(
                      onTap: () {
                        c.stageList.removeAt(stage);
                      },
                      child: const Icon(Icons.close))
                  : null,
            )
          ],
        ),
        formInput('完成内容', onChanged: (e) {
          c.stageList[stage]['content'] = e;
        }),
        GetBuilder<AddProjectController>(
            builder: (_) => Column(
                  children: <Widget>[
                    formInput('截止时间',
                        component: FormDateTimePicker((e) {
                          // c.stageList[stage]['endTime'] = e;
                          c.stageListMethod(stage, 'endTime', e);
                          print(c.stageList);
                        }, c.stageList[stage]['endTime'])),
                    formInput('完成频率',
                        component: FormDateTimePicker((e) {
                          // c.stageList[stage]['frequency'] = e;
                          c.stageListMethod(stage, 'frequency', e);
                          print(c.stageList);
                        }, frequencytoString(c.stageList[stage]['frequency']),
                            type: 1)),
                    formInput('提醒时间',
                        component: FormDateTimePicker((e) {
                          // c.stageList[stage]['reminderTime'] = e;
                          c.stageListMethod(stage, 'reminderTime', e);
                          print(c.stageList);
                        },
                            reminderTimetoString(
                                c.stageList[stage]['reminderTime']),
                            type: 2)),
                  ],
                ))
      ],
    );
  }

  // 转换提醒时间为字符串
  reminderTimetoString(value) {
    if (value != null) {
      return c.ahead[value];
    }
  }

  // 转换频率为字符串
  frequencytoString(value) {
    if (value != null) {
      String temp = '';
      // 先转换周期
      temp = value['week'].map((e) {
        String temp = '';
        return (temp + c.weekList[e]);
      }).toString();

      return temp += value['time'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'addproject',
        title: '添加计划',
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Text('返回',
              style: TextStyle(color: Color.fromRGBO(240, 242, 243, 0.8))),
        ),
        ending: InkWell(
          onTap: () {
            // 集合所有数据
            var data = {
              'endTime': c.endTime.value,
              'isDivide': c.isDivide.value,
              'isJoin': c.isJoin.value,
              'isMatch': c.isMatch.value,
              'projectTitle': c.projectTitle.value,
              'frequency': c.frequency,
              'reminderTime': c.reminderTime.value,
              'stageList': c.stageList
            };
            print(data);
            Get.toNamed('/match');
          },
          child: const Text(
            '确定',
            style: TextStyle(color: Color.fromRGBO(240, 242, 243, 0.8)),
          ),
        ),
      ),
      body: GetX<AddProjectController>(
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.only(bottom: 109),
            children: <Widget>[
              const SizedBox(height: 15),
              // 头像
              Column(
                children: [
                  Neumorphic(
                    style: const NeumorphicStyle(
                        shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
                        shadowLightColorEmboss:
                            Color.fromRGBO(255, 255, 255, 1),
                        depth: -3,
                        color: Color.fromRGBO(238, 238, 246, 1),
                        // color: Color(0xffEFECF0),
                        boxShape: NeumorphicBoxShape.stadium()),
                    child: SizedBox(
                        height: 88,
                        width: 88,
                        child: InkWell(
                          onTap: c.selectImage,
                          child: c.image == null
                              ? const SizedBox()
                              : Image.file(
                                  File(c.image!.path),
                                  fit: BoxFit.cover,
                                ),
                        )),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('点击选择头像',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)))
                ],
              ),
              // 列表
              formInput('计划名称', onChanged: (e) {
                c.projectTitle.value = e;
              }),
              formInput('截止时间',
                  component: FormDateTimePicker((e) {
                    c.endTime.value = e.substring(0, 10);
                  }, c.endTime.value)),
              formInput('分阶段完成',
                  component: formSwitch('是', '否', c.isDivide.value, (index) {
                    c.isDivide.value = index;
                    print('分阶段完成：${c.isDivide}');
                  })),
              // 分阶段
              Visibility(
                  visible: c.isDivide.value == 0 ? true : false,
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                          shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
                          physics: const NeverScrollableScrollPhysics(), //禁止滚动
                          itemCount: c.stageList.length,
                          itemBuilder: (context, index) {
                            return columnModel(index);
                          }),
                      InkWell(
                        onTap: () {
                          if (c.stageList.length < 10) {
                            c.stageList.add({});
                          } else {}
                        },
                        child: Icon(Icons.add),
                      )
                    ],
                  )),
              //  不分阶段
              Visibility(
                  visible: c.isDivide.value == 0 ? false : true,
                  child: Column(
                    children: <Widget>[
                      formInput('完成频率',
                          component: FormDateTimePicker((e) {
                            c.frequency.value = e;

                            print(c.stageList);
                          }, frequencytoString(c.frequency.value), type: 1)),
                      formInput('提醒时间',
                          component: FormDateTimePicker((e) {
                            c.reminderTime.value = e;
                            print(c.stageList);
                          }, reminderTimetoString(c.reminderTime.value),
                              type: 2)),
                    ],
                  )),
              formInput('是否加入互助小组',
                  component: formSwitch('是', '否', c.isJoin.value, (index) {
                    c.isJoin.value = index;
                    print('是否加入互助小组${c.isJoin.value}');
                  })),
              Visibility(
                  visible: c.isJoin.value == 0 ? true : false,
                  child: formInput('匹配方式',
                      component:
                          formSwitch('系统匹配', '自行邀请', c.isMatch.value, (index) {
                        c.isMatch.value = index;
                        print('匹配方式${c.isMatch.value}');
                      })))
            ],
          );
        },
      ),
    );
  }
}
