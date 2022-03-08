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

  Widget getItemContainer(int item) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 5.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Text(
        '$item',
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
      color: Colors.blue,
    );
  }

  // 选择头像
  selectImage() {
    Get.bottomSheet(Container(
      height: 500,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(234, 236, 239, 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: const Text('取消'),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(top: 20, left: 36))),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('确认'),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(top: 20, right: 36))),
              ),
            ],
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              GridView.builder(
                  //解决无限高度问题
                  shrinkWrap: true,
                  //禁用滑动事件
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 4,
                      //纵轴间距
                      mainAxisSpacing: 20.0,
                      //横轴间距
                      crossAxisSpacing: 10.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return getItemContainer(index);
                  }),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  itemCount: 20,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return getItemContainer(index);
                  },
                ),
              )
            ],
          ))
        ],
      ),
    ));
  }
}
