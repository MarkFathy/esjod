import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:azkar/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification Created: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification Displayed: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('Notification Dismissed: ${receivedAction.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('Notification Action Received: ${receivedAction.id}');
  }
}

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final sh = sl<SharedPreferences>();

  static const _batteryChannel =
      MethodChannel('com.fourthpyramid.esjodapp/battery');

  // ============================================================
  // INITIALIZE
  // ============================================================
  Future<void> initializenotification() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'prayer_reminder',
        channelName: 'تذكير الصلاة',
        channelDescription: 'تنبيه الأذان لكل صلاة',
        defaultColor: const Color(0xFF33A1E0),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        playSound: true,
        enableVibration: false,
        criticalAlerts: true,
        locked: false,
        defaultPrivacy: NotificationPrivacy.Public,
        soundSource: 'resource://raw/adhan',
      ),
      NotificationChannel(
        channelKey: 'saly_channel',
        channelName: 'Saly Notifications',
        channelDescription: 'Hourly prayer on prophet',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        playSound: true,
        enableVibration: true,
        defaultPrivacy: NotificationPrivacy.Public,
        soundSource: 'resource://raw/saly',
      ),
    ], debug: true);

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // ============================================================
  // BATTERY OPTIMIZATION
  // ============================================================
  Future<bool> _isBatteryOptimizationExempt() async {
    try {
      final bool isExempt =
          await _batteryChannel.invokeMethod('isIgnoringBatteryOptimizations');
      return isExempt;
    } catch (e) {
      debugPrint('Battery Check Error: $e');
      return false;
    }
  }

  Future<void> requestBatteryOptimizationExemption() async {
    try {
      if (!Platform.isAndroid) return;

      // تحقق من Android مباشرةً — لو معفي متعملش حاجة
      final isExempt = await _isBatteryOptimizationExempt();
      if (isExempt) return;

      const intent = AndroidIntent(
        action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
        data: 'package:com.fourthpyramid.esjodapp',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );

      await intent.launch();
    } catch (e) {
      debugPrint('Battery Optimization Error: $e');
    }
  }

  // ============================================================
  // PRAYER NOTIFICATIONS — 30 يوم
  // ============================================================
  Future<void> backgroundtask(PrayerTimes value, int dayOffset) async {
    await _schedulePrayerTimeNotification(
        value.fajr.toLocal(), 'الفجر', dayOffset);
    await _schedulePrayerTimeNotification(
        value.dhuhr.toLocal(), 'الظهر', dayOffset);
    await _schedulePrayerTimeNotification(
        value.asr.toLocal(), 'العصر', dayOffset);
    await _schedulePrayerTimeNotification(
        value.maghrib.toLocal(), 'المغرب', dayOffset);
    await _schedulePrayerTimeNotification(
        value.isha.toLocal(), 'العشاء', dayOffset);
  }

  Future<void> cancelPrayerNotifier() async {
    final prayers = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    for (int dayOffset = 0; dayOffset < 30; dayOffset++) {
      for (final prayerName in prayers) {
        final int notificationId = '${prayerName}_$dayOffset'.hashCode;
        await AwesomeNotifications().cancel(notificationId);
      }
    }
  }

  Future<void> _schedulePrayerTimeNotification(
    DateTime prayerTime,
    String prayerName,
    int dayOffset,
  ) async {
    final int notificationId = '${prayerName}_$dayOffset'.hashCode;

    if (prayerTime.isBefore(DateTime.now())) {
      debugPrint('SKIPPED OLD NOTIFICATION => $prayerName');
      return;
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'prayer_reminder',
        title: 'وقت صلاة $prayerName',
        body: 'حان الآن موعد أذان $prayerName',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        autoDismissible: true,
        wakeUpScreen: true,
        fullScreenIntent: false,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      schedule: NotificationCalendar(
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        year: prayerTime.year,
        month: prayerTime.month,
        day: prayerTime.day,
        hour: prayerTime.hour,
        minute: prayerTime.minute,
        second: 0,
        preciseAlarm: true,
        allowWhileIdle: true,
        repeats: false,
      ),
    );

    debugPrint('NOTIFICATION SCHEDULED => $prayerName at $prayerTime');
  }

  // ============================================================
  // SALY NOTIFICATIONS — 72 ساعة (3 أيام)
  // ============================================================
  Future<void> schedulePrayOnMuhammedNotification() async {
    await cancelSalyNotifier();

    final String timeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    final now = DateTime.now();

    for (int i = 1; i <= 72; i++) {
      final scheduledTime = now.add(Duration(hours: i));
      final int notificationId = 'saly_$i'.hashCode;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'saly_channel',
          title: 'الصلاة على النبي ﷺ',
          body: 'إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          autoDismissible: true,
          wakeUpScreen: true,
          fullScreenIntent: false,
        ),
        schedule: NotificationCalendar(
          timeZone: timeZone,
          year: scheduledTime.year,
          month: scheduledTime.month,
          day: scheduledTime.day,
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: 0,
          preciseAlarm: true,
          allowWhileIdle: true,
          repeats: false,
        ),
      );
    }

    await sh.setString(
        '/saly_last_scheduled', DateTime.now().toIso8601String());
    debugPrint('SALY: 72 notifications scheduled ✅');
  }

  Future<void> cancelSalyNotifier() async {
    for (int i = 1; i <= 720; i++) {
      await AwesomeNotifications().cancel('saly_$i'.hashCode);
    }
    await AwesomeNotifications().cancel('saly'.hashCode);
  }

  // ============================================================
  // تحقق إذا محتاج تجديد — كل 1 يوم
  // ============================================================
  bool needsSalyRenewal() {
    final lastScheduled = sh.getString('/saly_last_scheduled');
    if (lastScheduled == null) return true;

    final lastDate = DateTime.parse(lastScheduled);
    final daysSince = DateTime.now().difference(lastDate).inDays;

    return daysSince >= 1;
  }
}