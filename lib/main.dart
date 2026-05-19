import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:azkar/src/core/services/notifications_services.dart';
import 'package:azkar/src/core/services/prayer_times_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'src/app.dart';
import 'src/injection_container.dart' as di;

final notiService = NotificationService();
final prayerService = PrayerTimesService();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await di.init();
      await NotificationService().initializenotification();

      if (task == 'updatePrayerTimes') {
        final prayerServ = PrayerTimesService();
        await prayerServ.initialPrayerTimes(forceRefresh: true, isBackground: true);

        final sh = di.sl<SharedPreferences>();
        bool salyOn = sh.getBool('/saly') ?? true;
        if (salyOn) {
          await NotificationService().schedulePrayOnMuhammedNotification();
        }
        debugPrint('Workmanager: Prayers & Saly renewed ✅');
      }

      return Future.value(true);
    } catch (e) {
      debugPrint('Workmanager error: $e');
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: false,
    ),
  );

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.fourthpyramid.esjodapp.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );

  await di.init();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  await Workmanager().registerPeriodicTask(
    'updatePrayerTimes',
    'updatePrayerTimes',
    frequency: const Duration(hours: 12),
    initialDelay: const Duration(minutes: 15),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    constraints: Constraints(
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );

  runApp(const MyApp());

  // كل حاجة تانية بعد ما الـ UI يبني
  // ملاحظة: battery exemption اتنقلت للـ IntroScreen
  Future.delayed(const Duration(seconds: 1), () async {
    await initialBgTaska();
    await _requestAndroidPermissions();
  });
}

Future<void> _requestAndroidPermissions() async {
  if (!Platform.isAndroid) return;

  // battery exemption بتتعمل في IntroScreen مش هنا
  bool isPrecisionAllowed = await AwesomeNotifications().checkPermissionList(
    permissions: [NotificationPermission.PreciseAlarms],
  ).then((list) => list.contains(NotificationPermission.PreciseAlarms));

  if (!isPrecisionAllowed) {
    await AwesomeNotifications().showAlarmPage();
  }
}

Future<void> initialBgTaska() async {
  final sh = di.sl<SharedPreferences>();

  bool prayerOn = sh.getBool('/prayer') ?? true;
  bool salyOn = sh.getBool('/saly') ?? true;

  sh.setBool('/prayer', prayerOn);
  sh.setBool('/saly', salyOn);

  if (prayerOn || salyOn) {
    await notiService.initializenotification();
  }

  if (salyOn) {
    if (notiService.needsSalyRenewal()) {
      await notiService.schedulePrayOnMuhammedNotification();
    }
  } else {
    await notiService.cancelSalyNotifier();
  }

  if (prayerOn) {
    await _scheduleDailyPrayerTimes();
  } else {
    await notiService.cancelPrayerNotifier();
  }
}

Future<void> _scheduleDailyPrayerTimes() async {
  await prayerService.initialPrayerTimes(forceRefresh: true);
}