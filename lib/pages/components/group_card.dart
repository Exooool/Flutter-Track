import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/public_card.dart';

class GroupCard extends StatefulWidget {
  final List userList;
  final bool type; // true表示为匹配成功
  final Function? delete;
  const GroupCard(this.userList, {Key? key, this.type = true, this.delete})
      : super(key: key);

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  int index = 0;
  bool showClose = false;

  Widget mathcedUserItem(
      int pos, String img, String projectName, String frequency) {
    return InkWell(
      onTap: () {
        index = pos;
        setState(() {});
        print(index);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: SizedBox(
                height: 48.r,
                width: 48.r,
                child: img == ''
                    ? Image.asset('lib/assets/images/defaultUserImg.png')
                    : Image.network(
                        img,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(width: 4.w),
            Visibility(
              visible: pos == index ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(projectName,
                      style: TextStyle(fontSize: MyFontSize.font18)),
                  Row(
                    children: [
                      // Text('在线 ', style: TextStyle(fontSize: MyFontSize.font12)),
                      Text('每天23:30',
                          style: TextStyle(fontSize: MyFontSize.font12))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mathingUserItem(Map? m) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: ClipOval(
        child: m == null
            ? Opacity(
                opacity: 0.2,
                child: Container(
                  height: 48.r,
                  width: 48.r,
                  color: Colors.white,
                  child: Image.asset('lib/assets/images/logo.png'),
                ),
              )
            : SizedBox(
                height: 48.r,
                width: 48.r,
                child: m['user_img'] == ''
                    ? Image.asset('lib/assets/images/defaultUserImg.png')
                    : Image.network(
                        m['user_img'],
                        fit: BoxFit.cover,
                      ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PublicCard(
            radius: 90.r,
            onLongPress: () {
              showClose = !showClose;
              setState(() {});
            },
            onTap: () {
              showClose = false;
              setState(() {});
            },
            padding: EdgeInsets.all(12.r),
            margin: EdgeInsets.only(
                left: 24.w, right: 24.w, top: 10.h, bottom: 10.h),
            widget: widget.type
                ? SizedBox(
                    height: 48.r,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.userList.length,
                        itemBuilder: (context, index) {
                          return mathcedUserItem(
                              index,
                              widget.userList[index]['user_img'],
                              widget.userList[index]['project_title'],
                              widget.userList[index]['frequency']);
                        }),
                  )
                : Row(
                    children: <Widget>[
                      mathingUserItem(widget.userList[0]),
                      mathingUserItem(widget.userList.length < 2
                          ? null
                          : widget.userList[1]),
                      mathingUserItem(widget.userList.length < 3
                          ? null
                          : widget.userList[2]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('互助小组匹配中',
                              style: TextStyle(fontSize: MyFontSize.font18)),
                          Text('已成功匹配 ${widget.userList.length - 1} 人',
                              style: TextStyle(fontSize: MyFontSize.font12)),
                        ],
                      )
                    ],
                  )),
        Visibility(
          visible: showClose,
          child: PublicCard(
              radius: 90.r,
              height: 36.r,
              width: 36.r,
              onTap: () {
                widget.delete!(widget.userList[0]['group_id']);
              },
              margin: EdgeInsets.only(left: 24.w),
              widget: Center(
                child: Image.asset('lib/assets/icons/Close.png',
                    height: 25.r, width: 25.r),
              )),
        )
      ],
    );
  }
}
