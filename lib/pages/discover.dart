import 'package:flutter/material.dart';
import './discover/news.dart';
import 'components/custom_appbar.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: createAppbar('discover'),
          body: TabBarView(children: <Widget>[
            NewsComponent(),
            Center(
              child: const Text('2'),
            ),
          ]),
        ));
  }
}
