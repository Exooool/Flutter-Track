import 'package:flutter/material.dart';
import 'package:flutter_track/pages/discover.dart';
import 'package:flutter_track/pages/user.dart';
import 'package:flutter_track/pages/project.dart';
import 'package:flutter_track/pages/information.dart';

class HomeMenu extends StatefulWidget {
  HomeMenu({Key? key}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  int index = 0;
  final List _pageList = [
    ProjectPage(),
    DiscoverPage(),
    InformationPage(),
    UserPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: '计划'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '发现'),
          BottomNavigationBarItem(
              icon: Icon(Icons.data_saver_off), label: '数据'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '个人'),
        ],
      ),
    );
  }
}
