import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart';

class ArticleCommentController extends GetxController {
  RxList commentList = [].obs;
  final arguments = Get.arguments;
  RxString comment = ''.obs;

  getComment() {
    DioUtil().post('/news/getComment', data: arguments, success: (res) {
      print(res);
      commentList.value = res['data'];
    }, error: (error) {
      print(error);
    });
  }

  @override
  void onInit() {
    super.onInit();

    getComment();
  }
}

class ArticleComment extends StatelessWidget {
  ArticleComment({Key? key}) : super(key: key);
  final ArticleCommentController c = Get.put(ArticleCommentController());
  final controller = TextEditingController();

  Widget commentItem(data) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: <Widget>[
              ClipOval(
                  child: data['user_img'] == ''
                      ? Image.asset('lib/assets/images/defaultUserImg.png',
                          height: 56.r, width: 56.r, fit: BoxFit.cover)
                      : Image.network(data['user_img'],
                          height: 56.r, width: 56.r, fit: BoxFit.cover)),
              SizedBox(width: 12.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      data['user_id'] == c.arguments['user_id']
                          ? data['user_name'] + '(作者)'
                          : data['user_name'],
                      style: TextStyle(
                          fontSize: MyFontSize.font16,
                          fontFamily: MyFontFamily.pingfangSemibold)),
                  SizedBox(
                      width: 220.w,
                      child: Text(data['content'],
                          style: TextStyle(
                              fontSize: MyFontSize.font12,
                              fontFamily: MyFontFamily.pingfangRegular)))
                ],
              ),
            ],
          ),
          Text(
              formatDate(DateTime.parse(data['comment_time']),
                  [yyyy, '.', mm, '.', dd]),
              style: TextStyle(
                  fontSize: MyFontSize.font12,
                  fontFamily: MyFontFamily.sfDisplayRegular))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: GetX<ArticleCommentController>(builder: (_) {
        return Stack(
          children: <Widget>[
            ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                itemCount: c.commentList.length,
                itemBuilder: (context, index) {
                  return commentItem(c.commentList[index]);
                }),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: MediaQueryData.fromWindow(window).size.width,
                height: 100.h,
                child: BlurWidget(
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: PublicCard(
                        radius: 10.r,
                        margin: EdgeInsets.only(left: 24.w, right: 12.w),
                        padding:
                            EdgeInsets.only(left: 24.w, top: 8.h, bottom: 8.h),
                        widget: TextField(
                          onChanged: (value) {
                            c.comment.value = value;
                          },
                          controller: controller,
                          style: TextStyle(
                              fontSize: MyFontSize.font16,
                              fontFamily: MyFontFamily.pingfangRegular),
                          decoration: InputDecoration.collapsed(
                              hintText: '请输入你的内容',
                              hintStyle: TextStyle(
                                  fontSize: MyFontSize.font16,
                                  fontFamily: MyFontFamily.pingfangRegular)),
                        ),
                      )),
                      PublicCard(
                          radius: 10.r,
                          notWhite: true,
                          onTap: () {
                            if (c.comment.value == '') {
                              Get.snackbar('提示', '请不要评论空内容');
                            } else {
                              DioUtil().post('/news/insertComment', data: {
                                'news_id': c.arguments['news_id'],
                                'user_id': c.arguments['news_id'],
                                'content': c.comment.value
                              }, success: (res) {
                                print(res);
                                Get.snackbar('提示', '评论成功');
                                controller.text = '';
                                c.getComment();
                              }, error: (error) {
                                print(error);
                              });
                            }
                          },
                          margin: EdgeInsets.only(right: 24.w),
                          padding: EdgeInsets.only(
                              left: 18.w, right: 18.w, top: 8.h, bottom: 8.h),
                          widget: Text(
                            '发布',
                            style: TextStyle(
                                fontSize: MyFontSize.font16,
                                color: MyColor.fontWhite,
                                fontFamily: MyFontFamily.pingfangRegular),
                          ))
                    ],
                  ),
                  radius: 20.r,
                  backBlur: false,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
