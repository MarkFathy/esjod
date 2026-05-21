import 'dart:io';

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

class _SettingsViewState extends State<SettingsView> with WidgetsBindingObserver {
  final SharedPreferences sh = sl<SharedPreferences>();
  late bool prayerRemainder;
  late bool salyOnMuhammed;
  bool _isBatteryExempt = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load initial values from SharedPreferences, default to true if null
    prayerRemainder = sh.getBool('/prayer') ?? true;
    salyOnMuhammed = sh.getBool('/saly') ?? true;
    _checkBatteryStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBatteryStatus();
    }
  }

  Future<void> _checkBatteryStatus() async {
    final isExempt = await NotificationService().isBatteryOptimizationExempt();
    if (mounted) {
      setState(() {
        _isBatteryExempt = isExempt;
      });
    }
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
            if (Platform.isAndroid) ...[
              const SizedBox(height: 8),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: CircleAvatar(
                    backgroundColor: _isBatteryExempt 
                        ? Colors.green[50] 
                        : Colors.orange[50],
                    child: Icon(
                      _isBatteryExempt ? Icons.verified_user : Icons.battery_alert,
                      color: _isBatteryExempt ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(
                    'العمل دائماً في الخلفية',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    _isBatteryExempt
                        ? 'مسموح به (يعمل بشكل ممتاز لتفادي تأخر الأذان)'
                        : 'غير مسموح به (قد يتأخر الأذان أو يتوقف التطبيق بسبب توفير البطارية)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _isBatteryExempt ? Colors.green : Colors.orange[800],
                    ),
                  ),
                  trailing: _isBatteryExempt
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : ElevatedButton(
                          onPressed: () async {
                            await NotificationService().requestBatteryOptimizationExemption();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('سماح'),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
