import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/project_model.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/project/project_controller.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import 'invite_group.dart';
import 'match_group.dart';

class AddProjectController extends GetxController {
  // 修改计划时需要
  // 计划id
  int? projectId;
  // 互助小组id
  int? groupId;
  // 表单数据
  // 截止时间
  var endTime = ''.obs;
  // 单次时长
  var singleTime = {}.obs;
  // 分阶段
  var isDivide = 0.obs;
  // 互助小组
  var isJoin = 0.obs;
  // 匹配方式
  var isMatch = 0.obs;
  // 标题
  var projectTitle = ''.obs;
  // 频率
  var frequency = {}.obs;
  // 提醒时间 9没有值 表示没有填写
  var reminderTime = 9.obs;
  // 阶段
  RxList stageList = [].obs;

  // 对stageList数组进行修改并刷新组件方法
  stageListMethod(index, key, value) {
    stageList[index][key] = value;
    update();
  }

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

  List weekList = ['一', '二', '三', '四', '五', '六', '日'];
  List ahead = ["到点提醒", "提前5分钟", "提前10分钟", "提前15分钟", "提前20分钟"];

  RxInt imageIndex = 0.obs;
  final ImagePicker _picker = ImagePicker();
  RxString imgUrl = ''.obs;
  // 上传图片并返回值
  Future pickImage() async {
    final file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 65);

    if (file != null) {
      dio.FormData formdata = dio.FormData.fromMap({
        "image":
            await dio.MultipartFile.fromFile(file.path, filename: file.name)
      });

      DioUtil().post('/article/imgPost', data: formdata, success: (success) {
        print(success);
        imgUrl.value = DioUtil.imgBaseUrl + '/' + success.toString();
      }, error: (error) {
        print(error);
      });
    }
  }

  // 头像Item
  Widget imageItem(String title, int index, String url) {
    return InkWell(
      onTap: () {
        imageIndex.value = index;
      },
      child: Opacity(
        opacity: imageIndex.value == index ? 1 : 0.5,
        child: Column(
          children: <Widget>[
            Image.asset(
              url,
              height: 103.r,
              width: 103.r,
              fit: BoxFit.cover,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: MyFontSize.font14,
                  fontFamily: MyFontFamily.pingfangMedium),
            )
          ],
        ),
      ),
    );
  }

  // 选择头像
  selectImage() {
    Get.bottomSheet(
        BlurWidget(
          SizedBox(
            height: 500.h,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text('取消',
                          style: TextStyle(
                              foreground: MyFontStyle.textlinearForeground,
                              fontFamily: MyFontFamily.pingfangSemibold)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(top: 20, left: 36))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        imgUrl.value = '${imageIndex.value + 1}';
                        Get.back();
                      },
                      child: Text('确认',
                          style: TextStyle(
                              foreground: MyFontStyle.textlinearForeground,
                              fontFamily: MyFontFamily.pingfangSemibold)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(top: 20, right: 36))),
                    ),
                  ],
                ),
                GetX<AddProjectController>(builder: (_) {
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(10.r),
                    childAspectRatio: 1,
                    children: <Widget>[
                      imageItem('学习提升', 0, 'lib/assets/images/project1.png'),
                      imageItem('升学', 1, 'lib/assets/images/project2.png'),
                      imageItem('生活习惯', 2, 'lib/assets/images/project3.png'),
                      imageItem('社交关系', 3, 'lib/assets/images/project4.png'),
                      imageItem('就业目标', 4, 'lib/assets/images/project5.png'),
                      imageItem('其它', 5, 'lib/assets/images/project6.png'),
                    ],
                  );
                }),
                PublicCard(
                    radius: 90.r,
                    height: 72.r,
                    width: 72.r,
                    onTap: () {
                      pickImage();
                      Get.back();
                    },
                    widget: Center(
                      child: Image.asset(
                        'lib/assets/icons/Add.png',
                        height: 44.r,
                        width: 44.r,
                      ),
                    ))
              ],
            ),
          ),
        ),
        barrierColor: Colors.transparent);
  }

  // 检查填入信息完整性

  bool checkInfo() {
    bool flag = true;
    if (projectTitle.value == '') {
      flag = false;
    } else if (isDivide.value == 0) {
      // 判断分阶段的情况
      for (var i = 0; i < stageList.length; i++) {
        if (stageList[i]['content'] == null ||
            stageList[i]['content'] == '' ||
            imgUrl.value == '' ||
            stageList[i]['endTime'] == '' ||
            stageList[i]['endTime'] == null ||
            stageList[i]['singleTime'] == null ||
            stageList[i]['frequency'] == null ||
            stageList[i]['reminderTime'] == 9) {
          flag = false;
        }
      }
      endTime.value = stageList[stageList.length - 1]['endTime'] ?? '';
    } else {
      stageList.value = [{}];
      // 判断不分阶段
      if (endTime.value == '' ||
          singleTime['type'] == null ||
          frequency['week'] == null ||
          imgUrl.value == '' ||
          reminderTime.value == 9) {
        flag = false;
      }
    }

    return flag;
  }

  // 添加计划
  addProject(data, matchFrequency) {
    DioUtil().post('/project/add', data: data, success: (res) {
      print(res);
      // 关闭加载动画
      Get.back();
      // 是否加入互助小组 0 是 1 否
      if (isJoin.value == 0) {
        // 选择匹配模式 0 系统匹配 1 自行邀请
        if (isMatch.value == 0) {
          Get.off(() => MatchGroup(), arguments: {
            'project_id': res['data']['project_id'],
            'frequency': matchFrequency
          });
        } else {
          Get.off(() => InviteGroup(), arguments: {
            'project_id': res['data']['project_id'],
            'frequency': matchFrequency
          });
        }
      } else {
        // 不加入互助小组
        print('请求成功,服务端返回:$res');
        if (res['status'] == 0) {
          Get.back();
          final ProjectController p = Get.find();
          p.getInfo();
          Get.snackbar('提示', '计划添加成功');
        }
      }
    }, error: (error) {
      Get.snackbar('提示', error);
      // print(error);
    });
  }

  // 修改计划
  alterProject(data, matchFrequency) {
    // 如果有小组  就退出之前加入的互助小组
    if (groupId != null) {
      DioUtil().post('/project/group/remove', data: {'group_id': groupId},
          success: (res) {
        print(res);
        if (res['status'] == 0) {
          print('原互助小组退出成功');
        }
      }, error: (error) {
        Get.snackbar('提示', '$error');
      });
    }

    data['project_id'] = projectId;

    DioUtil().post('/project/update', data: data, success: (res) {
      print(res);
      // 关闭加载动画
      Get.back();
      // 是否加入互助小组 0 是 1 否
      if (isJoin.value == 0) {
        // 选择匹配模式 0 系统匹配 1 自行邀请
        if (isMatch.value == 0) {
          Get.off(() => MatchGroup(), arguments: {
            'project_id': projectId,
            'frequency': matchFrequency
          });
        } else {
          Get.off(() => InviteGroup(), arguments: {
            'project_id': projectId,
            'frequency': matchFrequency
          });
        }
      } else {
        // 不加入互助小组
        print('请求成功,服务端返回:$res');
        if (res['status'] == 0) {
          Get.back();
          final ProjectController p = Get.find();
          p.getInfo();
          Get.snackbar('提示', '计划修改成功');
        }
      }
    }, error: (error) {
      Get.snackbar('提示', error);
      // print(error);
    });
  }

  alterInit() {
    final Project? project = Get.arguments;
    if (project == null) return;
    // print(project.stageList);
    imgUrl.value = project.projectImg;
    projectTitle.value = project.projectTitle;
    projectId = project.projectId;
    groupId = project.groupId;
    isDivide.value = project.stageList[0].isEmpty ? 1 : 0;
    isJoin.value = project.groupId != null ? 0 : 1;
    if (isDivide.value == 0) {
      stageList.value = project.stageList;
    } else {
      endTime.value = project.endTime.substring(0, 10);
      singleTime.value = project.singleTime;
      frequency.value = project.frequency;
      reminderTime.value = project.remainderTime;
    }
  }

  @override
  void onInit() {
    super.onInit();
    stageList.add({});
    alterInit();
    // print(groupId);
    // print(projectId);
  }
}
