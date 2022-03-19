import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//封装图片加载控件，增加图片加载失败时加载默认图片
class ImageWidget extends StatefulWidget {
  const ImageWidget(this.url, {Key? key, this.width, this.height, this.fit})
      : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  State<StatefulWidget> createState() {
    return _StateImageWidget();
  }
}

class _StateImageWidget extends State<ImageWidget> {
  final String defImagePath = '';
  late Image _image;

  @override
  void initState() {
    super.initState();

    // _image = Image.network(
    //   widget.url,
    //   width: widget.width,
    //   height: widget.height,
    //   fit: widget.fit,
    // );
    // var resolve = _image.image.resolve(ImageConfiguration.empty);
    // resolve.addListener(ImageStreamListener(
    //   (_, __) {
    //     //加载成功
    //     print('加载成功');
    //   },
    //   onError: (exception, stackTrace) {
    //     setState(() {
    //       _image = Image.asset(
    //         'lib/assets/images/404.jpg',
    //         height: widget.height,
    //         width: widget.width,
    //       );
    //     });
    //   },
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return _image;
  }
}
