import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyrka/zefyrka.dart';

class NewsEdit extends StatelessWidget {
  final ZefyrController _controller = ZefyrController();

  NewsEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
              child: InkWell(
                onTap: () {
                  // 富文本编辑器输出内容
                  print(jsonEncode(_controller.document));
                },
                child: Text('输出'),
              ),
            ),
            Expanded(
              child: ZefyrEditor(
                controller: _controller,
                embedBuilder: customZefyrEmbedBuilder,
              ),
            ),
            customToolBar(_controller)
          ],
        ),
      ),
    );
  }
}

Widget customToolBar(ZefyrController _controller) {
  return ZefyrToolbar(children: [
    ToggleStyleButton(
      attribute: NotusAttribute.bold,
      icon: Icons.format_bold,
      controller: _controller,
    ),
    const SizedBox(width: 1),
    ToggleStyleButton(
      attribute: NotusAttribute.italic,
      icon: Icons.format_italic,
      controller: _controller,
    ),
    const SizedBox(width: 1),
    ToggleStyleButton(
      attribute: NotusAttribute.underline,
      icon: Icons.format_underline,
      controller: _controller,
    ),
    const SizedBox(width: 1),
    ToggleStyleButton(
      attribute: NotusAttribute.strikethrough,
      icon: Icons.format_strikethrough,
      controller: _controller,
    ),
    VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
    CustomInsertImageButton(
      // 自定义图片上传组件
      controller: _controller,
      icon: Icons.image,
    ),
    VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
    SelectHeadingStyleButton(controller: _controller),
    VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
    ToggleStyleButton(
      attribute: NotusAttribute.block.numberList,
      controller: _controller,
      icon: Icons.format_list_numbered,
    ),
    ToggleStyleButton(
      attribute: NotusAttribute.block.bulletList,
      controller: _controller,
      icon: Icons.format_list_bulleted,
    ),
    ToggleStyleButton(
      attribute: NotusAttribute.block.code,
      controller: _controller,
      icon: Icons.code,
    ),
    VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
    ToggleStyleButton(
      attribute: NotusAttribute.block.quote,
      controller: _controller,
      icon: Icons.format_quote,
    )
  ]);
}

Widget customZefyrEmbedBuilder(BuildContext context, EmbedNode node) {
  if (node.value.type.contains('http://')) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        child: Column(
          children: [
            Image.network(
              node.value.type,
              fit: BoxFit.fill,
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
        final image = pickImage(gallerySource);
        // controller.replaceText(
        //     index,
        //     length,
        //     BlockEmbed(
        //         'http://10.0.0.2/track-api/runtime/storage/topic//20220309//301eab26aa7bb881291aefeabb8b8c9f.jpg'));
        // image.then((value) {
        //   print(value);
        //   controller.replaceText(index, length, BlockEmbed(value!));
        // });
      },
    );
  }
}

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
