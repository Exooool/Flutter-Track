import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:toggle_switch/toggle_switch.dart';
import 'component/form_datetime_picker.dart';

import '../components/custom_appbar.dart';

import 'add_project_controller.dart';

class AddProject extends StatelessWidget {
  AddProject({Key? key}) : super(key: key);
  final AddProjectController c = Get.put(AddProjectController());

  // 表单输入框
  Widget formInput(String title, {Widget? component, Function? onChanged}) {
    return Center(
      child: PublicCard(
        radius: 30.r,
        height: 48.h,
        width: 366.w,
        margin: EdgeInsets.only(bottom: 12.h),
        widget: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: MyFontSize.font16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 36.w),
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
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              fontWeight: FontWeight.w500,
                              color: MyColor.fontBlack),
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                              hintText: '请输入',
                              hintStyle: TextStyle(color: MyColor.fontBlackO2),
                              hintTextDirection: TextDirection.rtl,
                              border: InputBorder.none)))
            ],
          ),
        ),
      ),
    );
  }

  // 表单开关
  Widget formSwitch(String on, String off, int value, Function onChange) {
    return ToggleSwitch(
      minWidth: on.length == 1 ? 40.sp : 100.sp,
      fontSize: MyFontSize.font16,
      minHeight: 25.h,
      radiusStyle: true,
      cornerRadius: 60.r,
      inactiveBgColor: Colors.transparent,
      activeFgColor: Colors.white,
      inactiveFgColor: MyColor.fontBlackO2,
      activeBgColor: const [MyColor.mainColor, MyColor.secondColor],
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
              margin: EdgeInsets.only(bottom: 12.h),
              alignment: Alignment.center,
              child: Text(
                c.stageCH[stage],
                style: TextStyle(
                    fontSize: MyFontSize.font16,
                    fontWeight: FontWeight.w600,
                    foreground: MyFontStyle.textlinearForeground),
              ),
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
      resizeToAvoidBottomInset: true,
      appBar: CustomAppbar(
        'addproject',
        title: '添加计划',
        ending: InkWell(
          onTap: () {},
          child: const Text(
            '确定',
            style: TextStyle(color: Color.fromRGBO(240, 242, 243, 0.8)),
          ),
        ),
      ),
      body: GetX<AddProjectController>(
        builder: (controller) {
          return ListView(
            padding: EdgeInsets.only(bottom: 109.h),
            children: <Widget>[
              // 头像
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
                    child: PublicCard(
                      radius: 90.r,
                      height: 88.r,
                      width: 88.r,
                      onTap: c.selectImage,
                      widget: c.image == null
                          ? const SizedBox()
                          : Image.file(
                              File(c.image!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Text('点击选择头像',
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              fontWeight: FontWeight.w500)))
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
                        child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            child: Icon(Icons.add)),
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
                      }))),
              Center(
                child: CustomButton(
                    title: '确定计划',
                    fontSize: MyFontSize.font16,
                    height: 48.h,
                    width: 104.w,
                    onPressed: () {
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
                      if (c.isMatch.value == 0) {
                        Get.toNamed('/match_group');
                      } else {
                        Get.toNamed('/invite_group');
                      }
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}
