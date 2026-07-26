import 'package:azkar/src/features/settings/settings_view.dart';
import 'package:azkar/src/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';

import 'core/utils/core_theme.dart';
import 'features/home/home_screen.dart';
import 'features/intro/intro.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: themeLight,
      initialRoute: IntroScreen.routeName,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case HomeScreen.routeName:
                return UpgradeAlert(
                  showReleaseNotes: false,
                  showIgnore: false,
                  showLater: true,
                  upgrader: Upgrader(
                    minAppVersion: '1.5.5+32',
                    debugDisplayAlways: false,
                    debugLogging: false,
                    languageCode: 'ar',
                    messages: MyMessages(),
                    durationUntilAlertAgain: const Duration(days: 1),
                  ),
                  child: const HomeScreen(),
                );
              case '/settings':
                return const SettingsView();
              case IntroScreen.routeName:
              default:
                return const IntroScreen();
            }
          },
        );
      },
    );
  }
}



class MyMessages extends UpgraderMessages {
  @override
  String get title => 'تحديث جديد متاح';

  @override
  String get body =>
      'يوجد إصدار جديد من التطبيق، يُفضل التحديث الآن للحصول على أفضل تجربة وأداء محسّن.';

  @override
  String get buttonTitleUpdate => 'تحديث الآن';

  @override
  String get buttonTitleLater => 'لاحقاً';

  @override
  String get buttonTitleIgnore => 'تجاهل';

  @override
  String get prompt => 'هل تريد تحديث التطبيق الآن؟';

  @override
  String get releaseNotes => 'ما الجديد في هذا الإصدار';

  String get minAppVersionBody =>
      'هذا الإصدار لم يعد مدعومًا، يجب التحديث للمتابعة.';

  String get ignoreButton => 'متابعة بدون تحديث';

  String get laterButton => 'تذكير لاحقاً';

  String get updateButton => 'تحديث الآن';
}