import 'dart:math' as math;
import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final countdownSec, countdownMin, countdownHrs;
  const CountDownTimer(
      {super.key,
      required this.countdownHrs,
      required this.countdownMin,
      required this.countdownSec});
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController? controller;

  String get timerString {
    Duration duration = controller!.duration! * controller!.value;
    return '${(duration.inHours % 12).toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  startTimer() {
    if (controller!.isAnimating) {
      controller!.stop();
    } else {
      controller!
          .reverse(from: controller!.value == 0.0 ? 1.0 : controller!.value);
    }
  }

  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {});
    // });
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        hours: int.parse(widget.countdownHrs),
        minutes: int.parse(widget.countdownMin),
        seconds: int.parse(widget.countdownSec),
      ),
    );
    startTimer();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: controller!,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            Container(
              width: size.width * .4,
              height: size.width * .4,
              padding: const EdgeInsets.all(3.0),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor,
                  boxShadow: [BoxShadow(offset: Offset(.4, .3))]),
              child: Transform(
                transform: Matrix4.identity()..rotateY(-0.01 * 300),
                alignment: FractionalOffset.center,
                child: Transform.rotate(
                  angle: -1.56,
                  child: CustomPaint(
                    painter: ClockPainter(animController: controller!),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'الأذان بعد',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall!.copyWith(),
                ),
                Text(
                  timerString,
                  style: theme.textTheme.titleSmall!.copyWith(),
                )
              ],
            )
          ],
        );
      },
    );
  }
}

class ClockPainter extends CustomPainter {
  ClockPainter({
    this.animController,
  }) : super(repaint: animController);

  final AnimationController? animController;
  //60 sec - 360, 1 sec - 6degrees
  //12 hours - 360, 1 hour - 30degrees, 1 min - 0.5degrees

  @override
  void paint(Canvas canvas, Size size) {
    double initial, now, progress;

    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var radius = math.min(centerX, centerY);

    var dashBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    var longDashRadiusStart = radius;
    var longDashRadiusEnd = radius - 20;

    var shortDashRadiusStart = radius - 20;
    var shortDashRadiusEnd = radius - 19;

    initial = animController!.duration!.inMilliseconds.toDouble() / 1000;

    for (double i = 0; i <= 360; i += 8) {
      now = initial * animController!.value;

      // int progress = ((initial - now) / 1.33).floor(); // find constant value
      // progress *= 4; // find constant value

      progress = initial - now;
      double factor = initial / 45;
      double angle = (progress / factor) * 8;
      // print(
      //     'Initial: $initial, now: $now, I: $i, Angle: $angle, Progress: $progress');
      if (i > angle) {
        var xL1 = centerX + longDashRadiusStart * math.cos(i * math.pi / 180);
        var yL1 = centerX + longDashRadiusStart * math.sin(i * math.pi / 180);
        var xL2 = centerX + longDashRadiusEnd * math.cos(i * math.pi / 180);
        var yL2 = centerX + longDashRadiusEnd * math.sin(i * math.pi / 180);

        canvas.drawLine(Offset(xL1, yL1), Offset(xL2, yL2),
            dashBrush..color = primaryColor);
      } else {
        var xS1 = centerX + shortDashRadiusStart * math.cos(i * math.pi / 180);
        var yS1 = centerX + shortDashRadiusStart * math.sin(i * math.pi / 180);
        var xS2 = centerX + shortDashRadiusEnd * math.cos(i * math.pi / 180);
        var yS2 = centerX + shortDashRadiusEnd * math.sin(i * math.pi / 180);

        canvas.drawLine(Offset(xS1, yS1), Offset(xS2, yS2),
            dashBrush..color = primaryColor);
      }
    }
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return animController!.value != oldDelegate.animController!.value;
  }
}
