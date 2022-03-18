import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_track/common/style/my_style.dart';
import 'package:flutter_track/pages/components/custom_appbar.dart';
import 'package:flutter_track/pages/components/public_card.dart';
import 'package:get/get.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  Widget historyCard() {
    return PublicCard(
        radius: 20.r,
        height: 103.h,
        padding: EdgeInsets.only(left: 12.w, top: 12.h, bottom: 10.h),
        widget: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset('lib/assets/images/img.jpg',
                    fit: BoxFit.cover, height: 60.r, width: 60.r),
                Text(
                  'Gutabled',
                  style: TextStyle(fontSize: MyFontSize.font12),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('如何快速提高你的版式设计？',
                      style: TextStyle(
                          fontSize: MyFontSize.font18,
                          fontWeight: FontWeight.w500)),
                  Text('2021.01.02',
                      style: TextStyle(fontSize: MyFontSize.font12))
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        'history',
        leading: InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'lib/assets/icons/Refund_back.png',
            height: 25.r,
            width: 25.r,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        children: <Widget>[historyCard()],
      ),
    );
  }
}
