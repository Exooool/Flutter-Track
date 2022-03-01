import 'package:flutter/material.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/custom_button.dart';
import 'package:flutter_track/pages/components/custom_checkbox.dart';
import 'package:flutter_track/pages/components/search_input.dart';
import 'package:get/get.dart';

class InviteGroup extends StatelessWidget {
  const InviteGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'inviteGroup',
        title: '邀请好友',
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Text('返回')),
        ending: InkWell(onTap: () {}, child: const Text('下一步')),
      ),
      body: Column(
        children: <Widget>[
          SearchInput(
            height: 30,
            gradient: true,
            hintText: '搜索',
            onTap: () {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton('短信邀请',
                  shadow: false,
                  height: 44,
                  width: 112,
                  margin: const EdgeInsets.only(
                      left: 6, right: 6, top: 12, bottom: 12),
                  onPressed: () {}),
              CustomButton('复制链接',
                  shadow: false,
                  height: 44,
                  width: 112,
                  margin: const EdgeInsets.only(
                      left: 6, right: 6, top: 12, bottom: 12),
                  onPressed: () {}),
            ],
          ),
          const Text(
            '最多成立三人小组',
            style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.2)),
          ),
          Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, intindex) {
                    return ListTile(
                        leading: Icon(Icons.file_copy),
                        title: Text('名字'),
                        trailing:
                            CustomCheckBox(onChanged: (e) {}, value: false));
                  }))
        ],
      ),
    );
  }
}
