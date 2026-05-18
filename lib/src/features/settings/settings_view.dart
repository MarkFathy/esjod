import 'package:azkar/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azkar/src/core/services/notifications_services.dart';
import 'package:azkar/src/core/services/prayer_times_services.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SharedPreferences sh = sl<SharedPreferences>();
  late bool prayerRemainder;
  late bool salyOnMuhammed;

  @override
  void initState() {
    super.initState();
    // Load initial values from SharedPreferences, default to true if null
    prayerRemainder = sh.getBool('/prayer') ?? true;
    salyOnMuhammed = sh.getBool('/saly') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile.adaptive(
                value: prayerRemainder,
                title: Text(
                  'تنبيه الأذان',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('تفعيل أو إلغاء إشعارات مواقيت الصلاة والأذان'),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                onChanged: (val) async {
                  setState(() {
                    prayerRemainder = val;
                  });
                  await sh.setBool('/prayer', val);

                  if (val) {
                    await PrayerTimesService().initialPrayerTimes(forceRefresh: true);
                  } else {
                    await NotificationService().cancelPrayerNotifier();
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile.adaptive(
                value: salyOnMuhammed,
                title: Text(
                  'تنبيه الصلاة على النبى',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('تفعيل أو إلغاء التنبيه التذكيري بالصلاة على النبي كل ساعة'),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                onChanged: (val) async {
                  setState(() {
                    salyOnMuhammed = val;
                  });
                  await sh.setBool('/saly', val);

                  if (val) {
                    await NotificationService().schedulePrayOnMuhammedNotification();
                  } else {
                    await NotificationService().cancelSalyNotifier();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
