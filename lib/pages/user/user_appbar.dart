import 'package:flutter/material.dart';

class UserAppbar extends StatelessWidget {
  const UserAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
            onTap: () {},
            child: const Text(
              '寻找好友',
              style: TextStyle(fontSize: 12),
            )),
        const SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {},
            child: const Text(
              '分享',
              style: TextStyle(fontSize: 12),
            )),
        const SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {},
            child: const Text(
              '设置',
              style: TextStyle(fontSize: 12),
            )),
      ],
    );
  }
}
