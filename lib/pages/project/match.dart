import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../components/custom_appbar.dart';

class Match extends StatelessWidget {
  const Match({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar('match',
            leading: InkWell(
                onTap: () {},
                child: const Text('返回',
                    style:
                        TextStyle(color: Color.fromRGBO(240, 242, 243, 0.8))))),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Neumorphic(
                  style: const NeumorphicStyle(
                      shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
                      shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 1),
                      depth: -3,
                      color: Color.fromRGBO(238, 238, 246, 1),
                      // color: Color(0xffEFECF0),
                      boxShape: NeumorphicBoxShape.stadium(),
                      lightSource: LightSource.topLeft),
                  child: const SizedBox(
                    height: 120,
                    width: 120,
                  ),
                ),
                Neumorphic(
                  style: const NeumorphicStyle(
                      shadowDarkColorEmboss: Color.fromRGBO(8, 52, 84, 0.4),
                      shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 1),
                      depth: 3,
                      color: Color.fromRGBO(238, 238, 246, 1),
                      // color: Color(0xffEFECF0),
                      boxShape: NeumorphicBoxShape.stadium(),
                      lightSource: LightSource.topLeft),
                  child: const SizedBox(
                    height: 80,
                    width: 80,
                  ),
                ),
                CircularPercentIndicator(
                  radius: 60,
                  lineWidth: 20.0,
                  percent: 1,
                  animation: true,
                  animationDuration: 4000,
                  animateFromLastPercent: true,
                  startAngle: 270.0,
                  curve: Curves.easeOutSine,
                  restartAnimation: true,
                  // maskFilter: MaskFilter(),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                  linearGradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(107, 101, 244, 1),
                        Color.fromRGBO(51, 84, 244, 1)
                      ]),
                )
              ],
            ),
            const Text('正在匹配小组成员')
          ],
        )));
  }
}
