import 'dart:io';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:azkar/src/core/services/notifications_services.dart';
import 'package:azkar/src/core/services/prayer_times_services.dart';
import 'package:flutter/services.dart';
// import 'package:azkar/src/features/quran/presentation/widgets/audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:workmanager/workmanager.dart';
import 'src/app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'src/injection_container.dart' as di;
import 'package:timezone/data/latest_all.dart' as tz;

@pragma('vm:entry-point')
void setPrayerTimes() {
  final prayerServ = PrayerTimesService();
  prayerServ.initialPrayerTimes();
}

final notiService = NotificationService();
final prayerService = PrayerTimesService();

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
  await initialBgTaska();
  runApp(const MyApp());
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
    notiService.schedulePrayOnMuhammedNotification();
  } else {
    notiService.cancelSalyNotifier();
  }

  if (prayerOn) {
    tz.initializeTimeZones();

    await _scheduleDailyPrayerTimes();
  } else {
    notiService.cancelPrayerNotifier();
  }
}

Future<void> _scheduleDailyPrayerTimes() async {
  final prayerServ = PrayerTimesService();
  prayerServ.initialPrayerTimes();
}

// void test() async {
//   try {
//     final result = await InternetAddress.lookup('api.alquran.cloud');
//     print(result);
//   } catch (e) {
//     print('DNS ERROR: $e');
//   }
// }
















  //
  // Workmanager().executeTask((task, inputData) async {
//   try {

//   } catch (e) {
//     debugPrint(e.toString());
//   }

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     final player = AudioP.player;
//     player.open(Audio('assets/adhan.wav'),
//         autoStart: true,
//         forceOpen: true,
//         loopMode: LoopMode.none,
//         respectSilentMode: false,
//         showNotification: false,
//         playInBackground: PlayInBackground.enabled);
//     return Future.value(true);
//   });
// }