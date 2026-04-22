import 'package:azkar/src/features/home/widgets/countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrayerRemainTime extends StatefulWidget {
  final DateTime prayTime;

  const PrayerRemainTime({super.key, required this.prayTime});
  @override
  PrayerRemainTimeState createState() => PrayerRemainTimeState();
}

class PrayerRemainTimeState extends State<PrayerRemainTime> {
  DateTime? now, later, remaining;
  Duration? duration;
  String? hours, minutes, seconds, city;

  @override
  void initState() {
    super.initState();
    getDuration();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDuration() {
    try {
      now = DateTime.now();
      later = widget.prayTime;
      duration = later!.difference(now!);
      remaining = DateTime.fromMillisecondsSinceEpoch(duration!.inMilliseconds,
          isUtc: true);
      hours = remaining!.hour.toString();
      int m = remaining!.minute;
      minutes = m < 10 ? '0$m' : m.toString();
      int s = remaining!.second;
      seconds = s < 10 ? '0$s' : s.toString();

      // debugPrint('الآن: $now');
      // debugPrint('لاحقاً: $later');
      // debugPrint('المدة: $duration');
      // debugPrint('متبقى: $remaining');
      // debugPrint('س: $hours');
      // debugPrint('د: $minutes');
      // debugPrint('ث: $seconds');
    } catch (e) {
      // debugPrint('##getDuration##: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return counter();
  }

  counter() => CountDownTimer(
        countdownHrs: hours ?? '0',
        countdownMin: minutes ?? '0',
        countdownSec: seconds ?? '0',
      );
}
