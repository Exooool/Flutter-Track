import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_checkbox.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:flutter_track/service/service.dart';
import 'package:get/get.dart' as getx;
import 'package:image_picker/image_picker.dart';
import 'package:zefyrka/zefyrka.dart';

class NewsEdit extends StatelessWidget {
  late String newsTitle = '';
  final ZefyrController _controller = ZefyrController();
  NewsEdit({Key? key}) : super(key: key);

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
      appBar: CustomAppbar(
        'edit',
        leading: InkWell(
          onTap: () => getx.Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
        ending: SizedBox(
          height: 20,
          child: InkWell(
            onTap: () {
              // 富文本编辑器输出内容
              print(jsonEncode(_controller.document));

              if (newsTitle != '') {
                // 循环找出不是图片和超链接的内容存入content中
                String content = '';
                List target = jsonDecode(jsonEncode(_controller.document));
                for (var i = 0; i < target.length; i++) {
                  if (target[i]['insert'] is String &&
                      target[i]['attributes'] == null &&
                      target[i]['insert'] != '\n') {
                    print(target[i]['insert']);
                    content = target[i]['insert'];
                    break;
                  }
                }

                var jsondata = {
                  "news_title": newsTitle,
                  "news_content": jsonEncode(_controller.document),
                  "content": content
                };
                // Dio().post('http://10.0.2.2:3000/article/postArticle',
                //     data: jsondata);
                getx.Get.off(() => TagSelect(), arguments: jsondata);
              } else {
                getx.Get.snackbar('提示', '请填入标题');
              }
            },
            child: Image.asset(
              'lib/assets/icons/Send_hor_fill.png',
              height: 25.r,
              width: 25.r,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: Column(
          children: [
            PublicCard(
                radius: 10.r,
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 7.h, bottom: 7.h),
                widget: Center(
                  child: TextField(
                    onChanged: (value) {
                      newsTitle = value;
                    },
                    decoration: InputDecoration.collapsed(
                      enabled: true,
                      hintText: '请输入你的标题',
                      hintStyle: TextStyle(
                          fontSize: MyFontSize.font18,
                          fontFamily: MyFontFamily.pingfangSemibold,
                          color: MyColor.fontBlackO2),
                    ),
                  ),
                )),
            Expanded(
              child: Stack(
                children: [
                  PublicCard(radius: 10.r, widget: Container()),
                  ZefyrEditor(
                    // focusNode: null,
                    // readOnly: true,
                    autofocus: true,
                    padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 7.h),
                    controller: _controller,
                    embedBuilder: customZefyrEmbedBuilder,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            customToolBar(_controller)
          ],
        ),
      ),
    );
  }
}

Widget customToolBar(ZefyrController _controller) {
  return PublicCard(
    radius: 10.r,
    height: 36.h,
    margin: EdgeInsets.only(bottom: 34.h),
    widget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        customVideoInsertButton(),
        CustomLinkStyleButton(controller: _controller),
        CustomInsertImageButton(
            // 自定义图片上传组件
            controller: _controller),
      ],
    ),
  );
}

Widget customZefyrEmbedBuilder(BuildContext context, EmbedNode node) {
  if (node.value.type.contains('http://') ||
      node.value.type.contains('https://')) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              child: Image.network(
                node.value.type,
                fit: BoxFit.fill,
              ),
            ),
            // Text(node.value.type)
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen(node.value.type);
          }));
        },
      ),
    );
  }

  return Container();
}

class CustomInsertImageButton extends StatelessWidget {
  final ZefyrController controller;
  final ImagePicker _picker = ImagePicker();

  CustomInsertImageButton({Key? key, required this.controller})
      : super(key: key);

  pickImage() async {
    ImageSource gallerySource = ImageSource.gallery;
    final file =
        await _picker.pickImage(source: gallerySource, imageQuality: 65);
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (file != null) {
      FormData formdata = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: file.name)
      });
      // print('object');

      DioUtil().post('/article/imgPost', data: formdata, success: (res) {
        print(res);
        var info = DioUtil.imgBaseUrl + '/' + res.toString();
        controller.replaceText(index, length, BlockEmbed(info));
      }, error: (error) {
        print(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.asset('lib/assets/icons/Img_box_fill.png', height: 25.r),
      onTap: () {
        pickImage();
        // controller.replaceText(
        //     index,
        //     length,
        //     BlockEmbed(
        //         'https://img0.baidu.com/it/u=2064213898,2801034448&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'));
      },
    );
  }
}

// 图片的细节展示
class DetailScreen extends StatelessWidget {
  final String _image;
  const DetailScreen(this._image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: Image.network(_image, fit: BoxFit.contain)),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

// 视频上传按钮
Widget customVideoInsertButton() {
  return InkWell(
    child: Image.asset('lib/assets/icons/Video_file_fill.png', height: 25.r),
    onTap: () {
      getx.Get.snackbar('提示', '添加视频功能暂未开放');
    },
  );
}

// 标签选择页

class TagSelect extends StatefulWidget {
  TagSelect({Key? key}) : super(key: key);

  @override
  State<TagSelect> createState() => _TagSelectState();
}

class _TagSelectState extends State<TagSelect> {
  final _tagList = const [
    '校园',
    '语言',
    '升学',
    '心理',
    '文学',
    '生活',
    '运动',
    '读书',
    '哲学',
    '法学',
    '经济学',
    '艺术学',
    '教育学',
    '历史学',
    '理学',
    '工学',
    '农学',
    '医学',
    '管理学',
    '其它'
  ];

  int tagIndex = 0;

  @override
  Widget build(BuildContext context) {
    final arguments = getx.Get.arguments;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    // print(arguments);
    return Scaffold(
      appBar: CustomAppbar(
        'TagSelect',
        leading: InkWell(
          onTap: () => getx.Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
        ending: InkWell(
          onTap: () {
            arguments['hashtag'] = _tagList[tagIndex];
            // print(arguments);
            getx.Get.off(() => CoverSelect(), arguments: arguments);
          },
          child: Image.asset(
            'lib/assets/icons/Send_hor_fill.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 36.w, bottom: 14.h),
            child: Text(
              '请选择您的标签',
              style: TextStyle(
                  fontSize: MyFontSize.font18,
                  fontFamily: MyFontFamily.pingfangSemibold),
            ),
          ),
          Expanded(
              child: PublicCard(
                  radius: 10.r,
                  margin:
                      EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
                  widget: GridView.builder(
                      itemCount: _tagList.length,
                      padding:
                          EdgeInsets.only(top: 24.h, left: 10.w, right: 10.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          //横轴三个子widget
                          mainAxisSpacing: 30.h,
                          crossAxisSpacing: 15.w,
                          childAspectRatio: 2),
                      itemBuilder: (context, index) {
                        return Opacity(
                          opacity: tagIndex == index ? 1 : 0.5,
                          child: PublicCard(
                              notWhite: true,
                              radius: 90.r,
                              onTap: () {
                                tagIndex = index;
                                setState(() {});
                              },
                              widget: Center(
                                  child: Text(_tagList[index],
                                      style: TextStyle(
                                          fontSize: MyFontSize.font16,
                                          fontFamily:
                                              MyFontFamily.pingfangSemibold,
                                          color: MyColor.fontWhite)))),
                        );
                      })))
        ],
      ),
    );
  }
}

class CoverSelect extends StatefulWidget {
  CoverSelect({Key? key}) : super(key: key);

  @override
  State<CoverSelect> createState() => _CoverSelectState();
}

class _CoverSelectState extends State<CoverSelect> {
  final ImagePicker _picker = ImagePicker();

  late String imgUrl = '';
  int imgIndex = 0;
  List imgList = [
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1587685987799-73e5a5ec0878?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1638913976954-8f7b612867c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1647591413270-469a0393da0c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1647591609971-7ebb33c0f98a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0MHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1649105425917-fb091911a248?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw3fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1524758631624-e2822e304c36?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1497215728101-856f4ea42174?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyNXx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1649000808933-1f4aac7cad9a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1649084919367-51257e8a9142?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4Nnx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1648997121517-250cbdc74377?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw5Nnx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1649035075923-9301d4e01044?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNDJ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
    'https://dogefs.s3.ladydaily.com/~/source/unsplash/photo-1649023000556-f9c784ee48b1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNDV8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
  ];

  Widget imageItem(String address, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          imgIndex = index;
        });
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            child: Image.network(
              address,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              right: 0.r,
              top: 0.r,
              child: CustomCheckBox(
                  value: imgIndex.isEqual(index), onChanged: (e) {}))
        ],
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> list = [];
    for (var i = 0; i < imgList.length; i++) {
      list.add(imageItem(imgList[i], i));
    }
    list.add(PublicCard(
        radius: 10.r,
        widget: InkWell(
          onTap: pickImage,
          child: imgUrl == ''
              ? Center(
                  child: Image.asset(
                    'lib/assets/icons/Add_round_fill.png',
                    height: 27.r,
                    width: 27.r,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
        )));
    return list;
  }

  Future pickImage() async {
    final file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 65);

    if (file != null) {
      FormData formdata = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: file.name)
      });

      DioUtil().post('/article/imgPost', data: formdata, success: (res) {
        print(res);
        setState(() {
          imgIndex = -1;
          imgUrl = DioUtil.imgBaseUrl + '/' + res.toString();
        });
      }, error: (error) {
        print(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = getx.Get.arguments;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQueryData.fromWindow(window).size.width,
            maxHeight: MediaQueryData.fromWindow(window).size.height),
        designSize: const Size(414, 896),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    print(arguments);
    return Scaffold(
      appBar: CustomAppbar(
        'CoverSelect',
        leading: InkWell(
          onTap: () => getx.Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
        ending: InkWell(
          onTap: () {
            if (imgIndex != -1) {
              arguments['news_img'] = imgList[imgIndex];
            } else {
              arguments['news_img'] = imgUrl;
            }
            print('上传的数据：$arguments');
            DioUtil().post('/article/postArticle', data: arguments,
                success: (res) {
              print(res);
              if (res['status'] == 0) {
                getx.Get.back();
                getx.Get.snackbar('提示', '文章上传成功');
              }
            }, error: (error) {
              print(error);
            });
          },
          child: Image.asset(
            'lib/assets/icons/Send_fill.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 36.w, bottom: 14.h),
            child: Text(
              '请选择您的封面',
              style: TextStyle(
                  fontSize: MyFontSize.font18,
                  fontFamily: MyFontFamily.pingfangSemibold),
            ),
          ),
          Expanded(
              child: PublicCard(
                  radius: 10.r,
                  margin:
                      EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
                  widget: GridView(
                    padding:
                        EdgeInsets.only(top: 24.h, left: 10.w, right: 10.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        //横轴三个子widget
                        mainAxisSpacing: 30.h,
                        crossAxisSpacing: 20.w,
                        mainAxisExtent: 90.h,
                        childAspectRatio: 1),
                    children: getList(),
                  )))
        ],
      ),
    );
  }
}

// 自定义超链接按钮
class CustomLinkStyleButton extends StatefulWidget {
  final ZefyrController controller;

  const CustomLinkStyleButton({Key? key, required this.controller})
      : super(key: key);

  @override
  _CustomLinkStyleButtonState createState() => _CustomLinkStyleButtonState();
}

class _CustomLinkStyleButtonState extends State<CustomLinkStyleButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant CustomLinkStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeSelection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = !widget.controller.selection.isCollapsed;
    final pressedHandler = isEnabled ? () => _openLinkDialog(context) : null;
    return InkWell(
      child: Image.asset('lib/assets/icons/Link.png', height: 25.r),
      onTap: pressedHandler,
    );
  }

  void _openLinkDialog(BuildContext context) {
    showDialog<String>(
      barrierColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return const _CustomLinkDialog();
      },
    ).then(_linkSubmitted);
  }

  void _linkSubmitted(String? value) {
    if (value == null || value.isEmpty) return;
    widget.controller.formatSelection(NotusAttribute.link.fromString(value));
  }
}

class _CustomLinkDialog extends StatefulWidget {
  const _CustomLinkDialog({Key? key}) : super(key: key);

  @override
  _CustomLinkDialogState createState() => _CustomLinkDialogState();
}

class _CustomLinkDialogState extends State<_CustomLinkDialog> {
  String _link = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 160.h,
        width: 318.w,
        child: BlurWidget(
          Padding(
            padding: EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      '输入链接：',
                      style: TextStyle(
                          foreground: MyFontStyle.textlinearForeground),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: MyColor.mainColor, width: 2))),
                        child: TextField(
                          style: TextStyle(
                              foreground: MyFontStyle.textlinearForeground,
                              fontSize: MyFontSize.font16),
                          decoration: const InputDecoration.collapsed(
                              hintText: '', border: InputBorder.none),
                          autofocus: true,
                          onChanged: _linkChanged,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 30.h,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: MyColor.mainColor, width: 2))),
                  // child: TextField(
                  //   style: TextStyle(
                  //       foreground: MyFontStyle.textlinearForeground,
                  //       fontSize: MyFontSize.font16),
                  //   decoration: const InputDecoration.collapsed(
                  //       hintText: '', border: InputBorder.none),
                  //   autofocus: true,
                  //   onChanged: _linkChanged,
                  // ),
                ),
                PublicCard(
                  notWhite: true,
                  radius: 90.r,
                  height: 36.h,
                  width: 72.w,
                  margin: EdgeInsets.only(top: 24.h),
                  onTap: _link.isNotEmpty ? _applyLink : null,
                  widget: const Center(
                    child: Text(
                      '确定',
                      style: TextStyle(color: MyColor.fontWhite),
                    ),
                  ),
                )
              ],
            ),
          ),
          radius: 10.r,
        ),
      ),
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link);
  }
}
