import 'package:get/get.dart';

class UserController extends GetxController {
  List target = [
    {'title': '目标一'},
    {'title': '目标二'},
    {'title': '目标三'}
  ].obs;
  List collect = [
    {'title': '收藏一'},
    {'title': '收藏二'},
    {'title': '收藏三'}
  ].obs;
  List article = [
    {'title': '文章一'},
    {'title': '文章二'},
    {'title': '文章三'}
  ].obs;
}
