import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/blur_widget.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart' as getx;
import 'package:image_picker/image_picker.dart';
import 'package:zefyrka/zefyrka.dart';

class NewsEdit extends StatelessWidget {
  final doc = [
    {
      "insert": "12123",
      "attributes": {"i": true}
    },
    {"insert": "\n"},
    {
      "insert": "woshilianjie",
      "attributes": {"a": "http://www.baidu.com"}
    },
    {"insert": "\n"},
    {"insert": "\n"}
  ];

  NewsEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ZefyrController _controller =
        ZefyrController(NotusDocument.fromJson(doc));
    return Scaffold(
      appBar: CustomAppbar(
        'edit',
        ending: SizedBox(
          height: 20,
          child: InkWell(
            onTap: () {
              // 富文本编辑器输出内容
              print(jsonEncode(_controller.document));
              getx.Get.to(const TagSelect());
            },
            child: Text('输出'),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: Column(
          children: [
            PublicCard(
                radius: 10.r,
                height: 36.h,
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                widget: Center(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      enabled: true,
                      hintText: '请输入你的标题',
                      hintStyle: TextStyle(
                          fontSize: MyFontSize.font16,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customVideoInsertButton(),
        CustomLinkStyleButton(controller: _controller),
        CustomInsertImageButton(
          // 自定义图片上传组件
          controller: _controller,
          icon: Icons.image,
        ),
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
                loadingBuilder: (context, child, loadingProgress) {
                  return Text('图片加载中');
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text('图片加载失败');
                },
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
  final IconData icon;

  CustomInsertImageButton({
    Key? key,
    required this.controller,
    required this.icon,
  }) : super(key: key);

  //  Future<String> upload(File imageFile) async {
  //     // open a bytestream
  //     var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  //     // get file length
  //     var length = await imageFile.length();

  //     // string to uri
  //     var uri = Uri.parse(server + "/upload");

  //     // create multipart request
  //     var request = http.MultipartRequest("POST", uri);

  //     // multipart that takes file
  //     var multipartFile = http.MultipartFile('note', stream, length,
  //         filename: basename(imageFile.path));

  //     // add file to multipart
  //     request.files.add(multipartFile);

  //     // send
  //     var response = await request.send();
  //     // listen for response.join()
  //     return response.stream.transform(utf8.decoder).join();
  //   }

  Future<String?> pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 65);

    FormData formdata = FormData.fromMap({
      "image": await MultipartFile.fromFile(file!.path, filename: file.name)
    });

    var respone = await Dio()
        .post<String>("http://10.0.0.2/index.php/upload", data: formdata);
    print(respone);

    print(formdata);
    return 'http://10.0.0.2/track-api/runtime/storage/' +
        respone.toString().substring(1, respone.toString().length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(
        icon,
        size: 18,
        color: Theme.of(context).iconTheme.color,
      ),
      fillColor: Theme.of(context).canvasColor,
      onPressed: () {
        final index = controller.selection.baseOffset;
        final length = controller.selection.extentOffset - index;
        ImageSource gallerySource = ImageSource.gallery;
        // final image = pickImage(gallerySource);
        controller.replaceText(
            index,
            length,
            BlockEmbed(
                'https://img0.baidu.com/it/u=2064213898,2801034448&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'));
        // image.then((value) {
        //   print(value);
        //   controller.replaceText(index, length, BlockEmbed(value!));
        // });
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
  return ZIconButton(
    highlightElevation: 0,
    hoverElevation: 0,
    size: 32,
    icon: const Icon(
      Icons.video_call,
      size: 18,
    ),
    onPressed: () {
      getx.Get.snackbar('提示', '添加视频功能暂未开放');
    },
  );
}

// 标签选择页
class TagSelect extends StatelessWidget {
  const TagSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'TagSelect',
        ending: InkWell(
          onTap: () => getx.Get.to(const CoverSelect()),
          child: const Text('下一步'),
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
                  fontSize: MyFontSize.font18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
              child: PublicCard(
                  radius: 10.r,
                  margin:
                      EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
                  widget: Container()))
        ],
      ),
    );
  }
}

class CoverSelect extends StatelessWidget {
  const CoverSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'CoverSelect',
        ending: InkWell(
          onTap: () {},
          child: const Text('下一步'),
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
                  fontSize: MyFontSize.font18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
              child: PublicCard(
                  radius: 10.r,
                  margin:
                      EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
                  widget: Container()))
        ],
      ),
    );
  }
}

// 自定义超链接按钮
class CustomLinkStyleButton extends StatefulWidget {
  final ZefyrController controller;
  final IconData? icon;

  const CustomLinkStyleButton({
    Key? key,
    required this.controller,
    this.icon,
  }) : super(key: key);

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
    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(
        widget.icon ?? Icons.link,
        size: 18,
        color: isEnabled ? theme.iconTheme.color : theme.disabledColor,
      ),
      fillColor: Theme.of(context).canvasColor,
      onPressed: pressedHandler,
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
