import 'dart:convert';
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
        enableVibration: false, // Disabled as per user request for long audio
        criticalAlerts: true,
        locked: true, // Pro apps don't let you swipe away active alarms easily
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
    ], debug: false);

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );

    // Request Notification Permissions
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // ============================================================
  // BATTERY OPTIMIZATION & EXACT ALARM PERMISSIONS
  // ============================================================
  Future<bool> isBatteryOptimizationExempt() async {
    try {
      if (!Platform.isAndroid) return true;
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

      final isExempt = await isBatteryOptimizationExempt();
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

  Future<void> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      data: 'package:com.fourthpyramid.esjodapp',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    try {
      await intent.launch();
    } catch (e) {
      debugPrint('Exact Alarm Permission Error: $e');
    }
  }

  // ============================================================
  // PRAYER NOTIFICATIONS
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
    await AwesomeNotifications().cancelNotificationsByChannelKey('prayer_reminder');
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
        category: NotificationCategory.Reminder, // Reverted to Reminder so it doesn't loop
        autoDismissible: false, // User MUST explicitly interact to dismiss
        wakeUpScreen: true,
        fullScreenIntent: true, // Show over lock screen
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'STOP_ADHAN',
          label: 'إيقاف',
          autoDismissible: true,
          actionType: ActionType.DismissAction,
        ),
        NotificationActionButton(
          key: 'OPEN_APP',
          label: 'فتح التطبيق',
          autoDismissible: true,
          actionType: ActionType.Default,
        ),
      ],
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
  // HOURLY SALY NOTIFICATIONS
  // ============================================================
  Future<void> schedulePrayOnMuhammedNotification() async {
    await cancelSalyNotifier();

    final String timeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    // Get location to check prayer times
    final locData = sh.getString('/location');
    double lat = 30.0444;
    double lng = 31.2357;
    if (locData != null) {
      try {
        final map = jsonDecode(locData);
        lat = (map['latitude'] as num).toDouble();
        lng = (map['longitude'] as num).toDouble();
      } catch (e) {
        debugPrint('Error decoding location for Saly: $e');
      }
    }
    
    final coords = Coordinates(lat, lng);
    final params = CalculationMethod.egyptian.getParameters();
    
    DateTime now = DateTime.now();
    // Start 60 minutes from now, so it's not strictly at minute 0
    DateTime nextSaly = now.add(const Duration(minutes: 60));
    
    int scheduledCount = 0;
    
    // Schedule for 10 days (240 hours) so it keeps working even if the app isn't opened for a while.
    for (int i = 1; i <= 240; i++) {
      final prayerTimes = PrayerTimes(
        coords,
        DateComponents.from(nextSaly),
        params,
      );
      
      bool collision = false;
      final prayers = [
        prayerTimes.fajr.toLocal(),
        prayerTimes.dhuhr.toLocal(),
        prayerTimes.asr.toLocal(),
        prayerTimes.maghrib.toLocal(),
        prayerTimes.isha.toLocal()
      ];
      
      DateTime scheduledTime = nextSaly;
      do {
        collision = false;
        for (final p in prayers) {
          // If Saly is within 10 minutes of Adhan, delay it by 10 minutes and check again
          if (scheduledTime.difference(p).inMinutes.abs() <= 10) {
            collision = true;
            scheduledTime = scheduledTime.add(const Duration(minutes: 10));
            break;
          }
        }
      } while (collision);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 'saly_$i'.hashCode,
          channelKey: 'saly_channel',
          title: 'الصلاة على النبي ﷺ',
          body: 'إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          autoDismissible: true,
          wakeUpScreen: true,
          fullScreenIntent: false,
          groupKey: 'saly_group',
        ),
        schedule: NotificationCalendar(
          timeZone: timeZone,
          year: scheduledTime.year,
          month: scheduledTime.month,
          day: scheduledTime.day,
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: scheduledTime.second,
          preciseAlarm: true,
          allowWhileIdle: true,
          repeats: false,
        ),
      );
      
      nextSaly = nextSaly.add(const Duration(hours: 1));
      scheduledCount++;
    }

    await sh.setString(
        '/saly_last_scheduled', DateTime.now().toIso8601String());
    debugPrint('SALY: Scheduled $scheduledCount notifications ✅');
  }

  Future<void> cancelSalyNotifier() async {
    await AwesomeNotifications().cancelNotificationsByChannelKey('saly_channel');
  }

  // ============================================================
  // RENEWAL CHECKS
  // ============================================================
  bool needsSalyRenewal() {
    final lastScheduled = sh.getString('/saly_last_scheduled');
    if (lastScheduled == null) return true;

    final lastDate = DateTime.parse(lastScheduled);
    final daysSince = DateTime.now().difference(lastDate).inDays;

    return daysSince >= 1;
  }

  bool needsPrayerRenewal() {
    final lastScheduled = sh.getString('/prayer_last_scheduled');
    if (lastScheduled == null) return true;

    final lastDate = DateTime.parse(lastScheduled);
    final daysSince = DateTime.now().difference(lastDate).inDays;

    return daysSince >= 1;
  }
}