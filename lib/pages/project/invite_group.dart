import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_checkbox.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/project/project_controller.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class InviteGroupController extends GetxController {
  RxList selectIndex = [].obs;
  RxList focusList = [].obs;
  RxInt groupId = 0.obs;

  _getFocusList() {
    DioUtil().post('/users/getFocusOrBefocusList', data: {'type': 0},
        success: (res) {
      print(res);
      focusList.value = res['data'];
      print(focusList);
    }, error: (error) {
      print(error);
    });
  }

  _createGroup() {
    DioUtil().post('/project/group/create', data: {
      'project_id': Get.arguments['project_id'],
      'frequency': Get.arguments['frequency']
    }, success: (res) {
      debugPrint('$res');
      groupId.value = res['data']['group_id'];
    }, error: (error) {
      print(error);
    });
  }

  @override
  void onInit() {
    super.onInit();
    _getFocusList();
    // 创建互助小组
    _createGroup();
  }
}

class InviteGroup extends StatelessWidget {
  InviteGroup({Key? key}) : super(key: key);

  final InviteGroupController c = Get.put(InviteGroupController());
  final ProjectController p = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          'inviteGroup',
          title: '邀请好友',
          leading: InkWell(
            onTap: () {
              Get.back();
              p.getInfo();
            },
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
          ending: InkWell(
            onTap: () {
              List list = c.selectIndex.map((e) {
                return c.focusList[e]['user_id'];
              }).toList();

              print('被邀请人：$list');

              if (list.isEmpty) {
                Get.snackbar('提示', '你没有邀请任何人');
                Get.back();
                p.getInfo();
                return;
              }

              if (c.groupId.value != 0) {
                DioUtil().post('/project/invite', data: {
                  'invite': list,
                  'frequency': Get.arguments['frequency'],
                  'project_id': Get.arguments['project_id'],
                  'group_id': c.groupId.value
                }, success: (res) {
                  print(res);
                  if (res['status'] == 0) {
                    Get.back();
                    p.getInfo();
                    Get.snackbar('提示', '邀请成功');
                  } else {
                    Get.snackbar('提示', '邀请失败' + res);
                  }
                }, error: (error) {
                  print(error);
                });
              } else {
                Get.snackbar('提示', '创建互助小组失败');
              }
            },
            child: Image.asset(
              'lib/assets/icons/Send_fill.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
        ),
        body: GetX<InviteGroupController>(builder: (builder) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PublicCard(
                      radius: 90.r,
                      notWhite: true,
                      margin: EdgeInsets.only(
                          left: 6.w, right: 6.w, top: 12.h, bottom: 12.h),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 7.h, bottom: 7.h),
                      onTap: () {
                        Get.snackbar('提示', '暂时还未开放此功能');
                      },
                      widget: Text('短信邀请',
                          style: TextStyle(
                              fontFamily: MyFontFamily.pingfangRegular,
                              fontSize: MyFontSize.font16,
                              color: MyColor.fontWhite))),
                  PublicCard(
                    radius: 90.r,
                    notWhite: true,
                    margin: EdgeInsets.only(
                        left: 6.w, right: 6.w, top: 12.h, bottom: 12.h),
                    padding: EdgeInsets.only(
                        left: 20.w, right: 20.w, top: 7.h, bottom: 7.h),
                    onTap: () {
                      Get.snackbar('提示', '暂时还未开放此功能');
                    },
                    widget: Text('复制链接',
                        style: TextStyle(
                            fontFamily: MyFontFamily.pingfangRegular,
                            fontSize: MyFontSize.font16,
                            color: MyColor.fontWhite)),
                  ),
                ],
              ),
              Text(
                '最多成立三人小组',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: MyColor.fontBlackO2,
                  fontFamily: MyFontFamily.pingfangRegular,
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: c.focusList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (!c.selectIndex.contains(index) &&
                                c.selectIndex.length < 2) {
                              c.selectIndex.add(index);
                            } else {
                              c.selectIndex.remove(index);
                            }
                          },
                          child: ListTile(
                              leading: ClipOval(
                                child: c.focusList[index]['user_img'] == ''
                                    ? Image.asset(
                                        'lib/assets/images/defaultUserImg.png',
                                        height: 56.r,
                                        width: 56.r)
                                    : Image.network(
                                        c.focusList[index]['user_img'],
                                        height: 56.r,
                                        width: 56.r,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(
                                c.focusList[index]['user_name'],
                                style: TextStyle(
                                    fontSize: MyFontSize.font16,
                                    fontFamily: MyFontFamily.sfDisplaySemibold),
                              ),
                              trailing: Obx(() => CustomCheckBox(
                                  onChanged: (e) {},
                                  value: c.selectIndex.contains(index)))),
                        );
                      }))
            ],
          );
        }));
  }
}
