import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/config/http_config.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart' as dio;

class AddProjectController extends GetxController {
  XFile? image;

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
        imgUrl.value =
            'http://10.0.2.2/track-api-nodejs/public/images/article/' +
                success.toString();
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
              style: TextStyle(fontSize: MyFontSize.font14),
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
                              fontWeight: FontWeight.w600)),
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
                              fontWeight: FontWeight.w600)),
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
                    childAspectRatio: 1.2,
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
                    widget: Image.asset(
                      'lib/assets/icons/add.png',
                      height: 44.r,
                      width: 44.r,
                    ))
              ],
            ),
          ),
        ),
        barrierColor: Colors.transparent);
  }
}
