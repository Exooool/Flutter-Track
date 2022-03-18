import 'package:flutter/material.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(''),
      body: ListView(
        children: <Widget>[Row()],
      ),
    );
  }
}
