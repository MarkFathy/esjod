import 'dart:convert';
import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:just_audio/just_audio.dart';
import 'package:azkar/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final sh = sl<SharedPreferences>();

  NotificationService._internal();

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    debugPrint(title! + body!);
    final player = AudioPlayer();
    await player.setAsset('assets/adhan.wav');
    player.play();
  }

  Future<void> initializenotification() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }

    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: null,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void backgroundtask(PrayerTimes value, int dayOffset) {
    final currenttime = DateTime.now();

    if (value.fajr.toLocal().isAfter(currenttime)) {
      _schedulePrayerTimeNotification(value.fajr.toLocal(), 'الفجر', dayOffset);
    }
    if (value.dhuhr.toLocal().isAfter(currenttime)) {
      _schedulePrayerTimeNotification(value.dhuhr.toLocal(), 'الظهر', dayOffset);
    }
    if (value.asr.toLocal().isAfter(currenttime)) {
      _schedulePrayerTimeNotification(value.asr.toLocal(), 'العصر', dayOffset);
    }
    if (value.maghrib.toLocal().isAfter(currenttime)) {
      _schedulePrayerTimeNotification(value.maghrib.toLocal(), 'المغرب', dayOffset);
    }
    if (value.isha.toLocal().isAfter(currenttime)) {
      _schedulePrayerTimeNotification(value.isha.toLocal(), 'العشاء', dayOffset);
    }
  }

  Future<void> cancelPrayerNotifier() async {
    final prayers = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    for (int dayOffset = 0; dayOffset < 15; dayOffset++) {
      for (final prayerName in prayers) {
        final int notificationId = '${prayerName}_$dayOffset'.hashCode;
        await flutterLocalNotificationsPlugin.cancel(notificationId);
      }
    }
  }

  Future<void> cancelSalyNotifier() async {
    flutterLocalNotificationsPlugin.cancel('saly'.hashCode);
  }

  Future<void> schedulePrayOnMuhammedNotification() async {
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentSound: true,
      sound: 'saly.wav',
      presentAlert: true,
      presentBadge: true,
      presentBanner: true,
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'saly_channel_v2',
      'Secondary Channel',
      channelDescription: "saly",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('saly'),
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      'saly'.hashCode,
      'الصلاة على النبي ﷺ',
      'إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا',
      RepeatInterval.hourly,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> _schedulePrayerTimeNotification(
      DateTime prayerTime, String prayerName, int dayOffset) async {
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentSound: true,
      sound: 'adhan.wav',
      presentAlert: true,
      presentBadge: true,
      presentBanner: true,
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'prayer_channel_1',
      'Main Channel',
      channelDescription: "adan",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan'),
    );

    const NotificationDetails notificationDetails2 = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    final formattedTime = DateFormat('h:mm a').format(prayerTime);
    final int notificationId = '${prayerName}_$dayOffset'.hashCode;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'وقت صلاة $prayerName',
      'حان الأن موعد أذان $prayerName, $formattedTime',
      tz.TZDateTime.from(prayerTime, tz.local),
      notificationDetails2,
      payload: Platform.isIOS
          ? jsonEncode({
              'aps': {
                'alert': "Adhan Alert",
                'sound': "adhan.wav",
              }
            })
          : null,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}