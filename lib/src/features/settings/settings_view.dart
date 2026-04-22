import 'package:azkar/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final sh = sl<SharedPreferences>();
    bool? salyOnMuhammed = sh.getBool('/saly');
    bool? prayerRemainder = sh.getBool('/prayer');
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.all(AppDimensions.normalize(12.0)),
          //   child: Card(
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(
          //           horizontal: AppDimensions.normalize(10.0)),
          //       child: DropdownButton<ThemeMode>(
          //         value: controller.themeMode,
          //         onChanged: controller.updateThemeMode,
          //         underline: const Center(),
          //         alignment: Alignment.centerLeft,
          //         items: const [
          //           DropdownMenuItem(
          //             value: ThemeMode.system,
          //             child: Text('System Theme'),
          //           ),
          //           DropdownMenuItem(
          //             value: ThemeMode.light,
          //             child: Text('Light Theme'),
          //           ),
          //           DropdownMenuItem(
          //             value: ThemeMode.dark,
          //             child: Text('Dark Theme'),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const Spacer(),

          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: StatefulBuilder(builder: (context, changeState) {
              return SwitchListTile.adaptive(
                  value: prayerRemainder ?? false,
                  title: Text(
                    'تنبيه الأذان',
                    style: theme.textTheme.titleLarge,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  onChanged: prayerRemainder == null
                      ? null
                      : (val) {
                          changeState(
                              () => prayerRemainder = !prayerRemainder!);
                          sh.setBool('/prayer', prayerRemainder!);
                        });
            }),
          ),
          Card(
            child: StatefulBuilder(builder: (context, changeState) {
              return SwitchListTile.adaptive(
                  value: salyOnMuhammed ?? false,
                  title: Text(
                    'تنبيه الصلاة على النبى',
                    style: theme.textTheme.titleLarge,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  onChanged: salyOnMuhammed == null
                      ? null
                      : (val) {
                          changeState(() => salyOnMuhammed = !salyOnMuhammed!);
                          sh.setBool('/saly', salyOnMuhammed!);
                        });
            }),
          ),
        ],
      ),
    );
  }
}
