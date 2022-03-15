import 'package:flutter_track/assets/test.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  List target = (projectData['project'] as List<dynamic>).obs;
  List collect = ((data['data'] as Map)['news'] as List<dynamic>).obs;
  List article = ((data['data'] as Map)['news'] as List<dynamic>).obs;
}
