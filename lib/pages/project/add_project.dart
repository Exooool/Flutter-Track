import 'dart:convert';
import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';

import 'package:flutter_track/pages/components/custom_dialog.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/project/component/single_time.dart';

import 'package:get/get.dart';

import 'package:toggle_switch/toggle_switch.dart';
import 'component/form_datetime_picker.dart';

import '../components/custom_appbar.dart';

import 'add_project_controller.dart';

class AddProject extends StatelessWidget {
  AddProject({Key? key}) : super(key: key);
  final AddProjectController c = Get.put(AddProjectController());

  // 表单输入框
  Widget formInput(String title,
      {Widget? component, Function? onChanged, String? value}) {
    return Center(
      child: PublicCard(
        radius: 90.r,
        padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
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
                    fontSize: MyFontSize.font16,
                    fontFamily: MyFontFamily.pingfangMedium),
              ),
              SizedBox(width: 36.w),
              Expanded(
                  child: component != null
                      ? Container(
                          alignment: Alignment.centerRight,
                          child: component,
                        )
                      : TextField(
                          keyboardType: TextInputType.text,
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  // 设置内容
                                  text: value ?? '',
                                  // 保持光标在最后
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          offset: value == null
                                              ? 0
                                              : value.length)))),
                          onChanged: (v) {
                            onChanged!(v);
                          },
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              fontFamily: MyFontFamily.pingfangRegular,
                              color: MyColor.fontBlack),
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                              hintText: '请输入',
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: MyColor.fontBlackO2,
                                  fontFamily: MyFontFamily.pingfangRegular),
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
      fontSize: 16.sp,
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

  List<String> text = ['30分钟', '60分钟', '90分钟', '120分钟', '150分钟', '自定义'];

  String? textTransfom(data) {
    if (data != null && data['type'] != null) {
      if (data['type'] == 5) {
        return text[data['type']] + data['custom'].toString() + '分钟';
      }
      return text[data['type']];
    }
    return null;
  }

  // 单次时长
  Widget singleTimeBottomSheet(Map? data, Function onChanged) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
            SizedBox(
              height: 330.h,
              child: BlurWidget(SingleTime(onChanged)),
            ),
            barrierColor: Colors.transparent);
      },
      child: Text(
        textTransfom(data) ?? '请选择',
        style: textTransfom(data) == null
            ? TextStyle(color: MyColor.fontBlackO2, fontSize: MyFontSize.font16)
            : TextStyle(color: MyColor.fontBlack, fontSize: MyFontSize.font16),
      ),
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
                      child: Image.asset(
                        'lib/assets/icons/Trash.png',
                        height: 25.r,
                        width: 25.r,
                      ))
                  : null,
            )
          ],
        ),
        formInput('完成内容', value: c.stageList[stage]['content'], onChanged: (e) {
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
                        }, c.stageList[stage]['endTime'],
                            beforeEndTime: stage - 1 >= 0
                                ? c.stageList[stage - 1]['endTime']
                                : null,
                            afterEndTime: stage + 1 <= c.stageList.length - 1
                                ? c.stageList[stage + 1]['endTime']
                                : null)),
                    formInput('单次时长',
                        component: singleTimeBottomSheet(
                            c.stageList[stage]['singleTime'], (e) {
                          c.stageListMethod(stage, 'singleTime', e);
                        })),
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
    if (value != null && value != 9) {
      return c.ahead[value];
    }
  }

  // 转换频率为字符串
  frequencytoString(value) {
    if (value != null && value['week'] != null) {
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
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppbar(
        'addproject',
        title: '添加计划',
        leading: InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: GetX<AddProjectController>(
        builder: (controller) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              print('点击');
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 109.h),
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
                        widget: c.imgUrl.value == ''
                            ? Center(
                                child: Image.asset(
                                'lib/assets/icons/Add.png',
                                height: 51.r,
                                width: 51.r,
                              ))
                            : GetUtils.isNum(c.imgUrl.value)
                                ? ClipOval(
                                    child: Image.asset(
                                    'lib/assets/images/project${c.imgUrl.value}.png',
                                    fit: BoxFit.cover,
                                  ))
                                : ClipOval(
                                    child: Image.network(
                                    c.imgUrl.value,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text('点击选择头像',
                            style: TextStyle(
                                fontSize: MyFontSize.font16,
                                fontFamily: MyFontFamily.pingfangMedium)))
                  ],
                ),
                // 列表
                formInput('计划名称', value: c.projectTitle, onChanged: (e) {
                  c.projectTitle = e;
                }),
                formInput('分阶段完成',
                    component: formSwitch('是', '否', c.isDivide.value, (index) {
                      c.isDivide.value = index;
                      print('分阶段完成：${c.isDivide}');
                    })),
                Visibility(
                    visible: c.isDivide.value == 0 ? false : true,
                    child: Column(
                      children: <Widget>[
                        formInput('截止时间',
                            component: FormDateTimePicker((e) {
                              c.endTime.value = e.substring(0, 10);
                            }, c.endTime.value)),
                        formInput('单次时长',
                            component: singleTimeBottomSheet(c.singleTime, (e) {
                              c.singleTime.value = e;
                            })),
                      ],
                    )),
                // 分阶段
                Visibility(
                    visible: c.isDivide.value == 0 ? true : false,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
                              physics:
                                  const NeverScrollableScrollPhysics(), //禁止滚动
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
                                child: Image.asset(
                                  'lib/assets/icons/Add_round_fill.png',
                                  height: 25.r,
                                  width: 25.r,
                                )),
                          )
                        ],
                      ),
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
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: formInput('匹配方式',
                          component: SizedBox(
                            height: 26,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                formSwitch('系统匹配', '自行邀请', c.isMatch.value,
                                    (index) {
                                  c.isMatch.value = index;
                                  print('匹配方式${c.isMatch.value}');
                                })
                              ],
                            ),
                          )),
                    )),
                Center(
                  child: PublicCard(
                      radius: 90.r,
                      notWhite: true,
                      widget: Text(
                        '确定计划',
                        style: TextStyle(
                            fontSize: MyFontSize.font16,
                            color: MyColor.fontWhite,
                            fontFamily: MyFontFamily.pingfangSemibold),
                      ),
                      padding: EdgeInsets.only(
                          top: 13.h, bottom: 13.h, left: 20.w, right: 20.w),
                      onTap: () {
                        // 集合所有数据

                        bool flag = c.checkInfo();
                        String endTime = c.endTime.value;

                        // 统一数据
                        var data = {
                          'project_img': c.imgUrl.value,
                          'end_time': endTime,
                          'single_time': jsonEncode(c.singleTime),
                          'project_title': c.projectTitle,
                          'frequency': jsonEncode(c.frequency),
                          'remainder_time': c.reminderTime.value,
                          'stage_list': jsonEncode(c.stageList)
                        };

                        print(data);

                        // flag标志信息是否填写完整
                        if (flag) {
                          // 匹配用到的时间
                          late String matchFrequency;
                          if (c.isDivide.value == 1) {
                            matchFrequency = c.frequency['time'];
                          } else {
                            matchFrequency =
                                c.stageList[0]['frequency']['time'];
                          }
                          print(matchFrequency);

                          // 加载动画
                          Get.dialog(
                              Material(
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SpinKitFoldingCube(
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text('加载中')
                                  ],
                                ),
                              ),
                              barrierColor: Colors.transparent);

                          if (c.projectId == null) {
                            // 添加计划
                            c.addProject(data, matchFrequency);
                          } else {
                            // 修改计划
                            Get.dialog(
                              CustomDialog(
                                height: 330.h,
                                width: 318.w,
                                title: '提示',
                                content: '修改计划会重置所有数据！',
                                subContent: '如果有互助小组会退出原小组！',
                                onCancel: () {
                                  Get.back();
                                  Get.back();
                                },
                                onConfirm: () {
                                  Get.back();
                                  c.alterProject(data, matchFrequency);
                                },
                              ),
                              barrierColor: Colors.transparent,
                            );
                          }
                        } else {
                          Get.snackbar('提示', '请输入信息');
                        }
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
