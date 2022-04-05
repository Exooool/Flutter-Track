import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/model/user_model.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/pages/user/user_controller.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class AlterUserInfoController extends GetxController {
  RxString userName = ''.obs;
  RxString sex = ''.obs;
  RxString college = ''.obs;
  RxString major = ''.obs;
  RxString imgUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();
  // 上传图片并返回值
  Future pickImage() async {
    final file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 65);

    if (file != null) {
      dio.FormData formdata = dio.FormData.fromMap({
        "image":
            await dio.MultipartFile.fromFile(file.path, filename: file.name)
      });

      DioUtil().post('/article/imgPost', data: formdata, success: (res) {
        print(res);
        imgUrl.value = DioUtil.imgBaseUrl + '/' + res.toString();
      }, error: (error) {
        print(error);
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化
    if (Get.arguments != null) {
      final User u = Get.arguments;
      userName.value = u.userName;
      imgUrl.value = u.userImg;
      sex.value = u.sex;
      major.value = u.major;
      college.value = u.college;
    }
  }
}

class AlterUserInfo extends StatelessWidget {
  AlterUserInfo({Key? key}) : super(key: key);
  final AlterUserInfoController c = Get.put(AlterUserInfoController());
  final UserController u = Get.find();
  Widget formRow(String title, String initString, Function saveMethod) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PublicCard(
              radius: 30.r,
              padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
              width: 81.w,
              notWhite: true,
              widget: Center(
                child: Text(
                  // 标题
                  title,
                  style: TextStyle(
                      fontFamily: MyFontFamily.pingfangSemibold,
                      color: MyColor.white,
                      fontSize: MyFontSize.font16),
                ),
              )),
          const SizedBox(width: 12),
          PublicCard(
              radius: 30.r,
              padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
              width: 261.w,
              widget: TextField(
                controller: TextEditingController.fromValue(TextEditingValue(
                    // 设置内容
                    text: initString,
                    // 保持光标在最后
                    selection: TextSelection.fromPosition(TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: initString.length)))),
                onChanged: (value) {
                  saveMethod(value);
                },
                style: TextStyle(
                    fontSize: MyFontSize.font16,
                    fontFamily: MyFontFamily.pingfangMedium,
                    color: MyColor.fontBlack),
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                    hintText: '请输入',
                    hintTextDirection: TextDirection.rtl,
                    isCollapsed: true,
                    hintStyle: TextStyle(
                        fontSize: MyFontSize.font16,
                        fontWeight: FontWeight.w500,
                        color: MyColor.fontBlackO2),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 36.w, right: 36.w)),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          '',
          leading: InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              'lib/assets/icons/Refund_back.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
        ),
        body: GetX<AlterUserInfoController>(builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => c.pickImage(),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: ClipOval(
                    child: SizedBox(
                      height: 84.r,
                      width: 84.r,
                      child: c.imgUrl.value == ''
                          ? Image.asset('lib/assets/images/defaultUserImg.png')
                          : Image.network(
                              c.imgUrl.value,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
                child: Text('修改头像',
                    style: TextStyle(
                        fontSize: MyFontSize.font16,
                        fontFamily: MyFontFamily.pingfangMedium)),
              ),
              formRow('昵称', c.userName.value, (value) {
                // print(value);
                c.userName.value = value;
              }),
              formRow('性别', c.sex.value, (value) {
                // print(value);
                c.sex.value = value;
              }),
              formRow('专业', c.major.value, (value) {
                // print(value);
                c.major.value = value;
              }),
              formRow('学校', c.college.value, (value) {
                // print(value);
                c.college.value = value;
              }),
              PublicCard(
                  notWhite: true,
                  radius: 90.r,
                  margin: EdgeInsets.only(top: 36.h),
                  onTap: () {
                    debugPrint(
                        '头像： ${c.imgUrl.value},昵称：${c.userName.value},性别：${c.sex.value},专业：${c.major.value},学校：${c.college.value}');
                    DioUtil().post('/users/update', data: {
                      'user_name': c.userName.value,
                      'user_img': c.imgUrl.value,
                      'sex': c.sex.value,
                      'major': c.major.value,
                      'college': c.college.value
                    }, success: (res) {
                      print(res);
                      if (res['status'] == 0) {
                        Get.back();
                        Get.snackbar('提示', '修改成功');
                        u.getUserInfo();
                      }
                    }, error: (error) {
                      print(error);
                    });
                  },
                  padding: EdgeInsets.only(
                      left: 38.w, right: 38.w, top: 13.h, bottom: 13.h),
                  widget: Text('保存',
                      style: TextStyle(
                          fontSize: MyFontSize.font16,
                          fontFamily: MyFontFamily.pingfangSemibold,
                          color: MyColor.fontWhite)))
            ],
          );
        }));
  }
}
