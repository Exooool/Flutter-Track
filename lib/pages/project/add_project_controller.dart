import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class AddProjectController extends GetxController {
  // final ImagePicker _picker = ImagePicker();
  XFile? image;

  // 表单数据
  // 截止时间
  var endTime = ''.obs;
  // 分阶段
  var isDivide = 0.obs;
  // 互助小组
  var isJoin = 0.obs;
  // 匹配方式
  var isMatch = 0.obs;
  // 标题
  var projectTitle = ''.obs;
  // 频率
  var frequency = null.obs;
  // 提醒时间
  var reminderTime = null.obs;
  // 阶段
  var stageList = [{}].obs;

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

  // _getImage() async {
  //   //选择相册
  //   final pickerImages = await _picker.pickImage(source: ImageSource.gallery);
  //   if (mounted) {
  //     setState(() {
  //       if (pickerImages != null) {
  //         image = pickerImages;
  //         setState(() {});
  //         print('选择了一张照片');
  //         print(image?.path);
  //       } else {
  //         print('没有照片可以选择');
  //       }
  //     });
  //   }
  // }

  // 选择头像
  selectImage() {
    Get.bottomSheet(Container(
      height: 500,
      decoration: BoxDecoration(color: Color.fromRGBO(234, 236, 239, 1)),
    ));
  }
}
