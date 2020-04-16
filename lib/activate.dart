import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'dart:async';
import 'monitor.dart';
import 'package:iot/widgets/devicestatus.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_orientation/auto_orientation.dart';
class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    AutoOrientation.portraitAutoMode();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1800),
    );
    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    color: Colors.amber,
                    height:
                    controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
            SizedBox(height: 30,),

                      SizedBox(

                        child:   Center(child:TextLiquidFill(
                          waveColor: Colors.white,
                            text: 'Ozone Cleaning \n',
                          boxBackgroundColor: Colors.amber,
                          textStyle: TextStyle(fontSize: 45.0,  fontWeight: FontWeight.bold,   color: Colors.red),
                          boxHeight: 60.0,
                        ),
                      ),),

                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        animation: controller,
                                        backgroundColor: Colors.white,
                                        color: themeData.indicatorColor,
                                      )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 70,),
                                      Text(
                                        "Ozone Generation : 20 minute",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.red),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Ozone Destruction : 10 minute",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20,),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 112.0,
                                            color: Colors.white),
                                      ),
                                      Image.asset(
                                        "images/loading.gif",
                                        height: 100.0,

                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// colors.length >= 2


                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}