import 'package:azkar/src/core/utils/app_images.dart';
import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/features/home/widgets/douaa_card.dart';
import 'package:azkar/src/features/names_of_allah/presentation/names_section.dart';
import 'package:flutter/material.dart';
import 'package:azkar/src/core/utils/extentions.dart';
import 'package:azkar/src/core/utils/nav.dart';
import 'package:azkar/src/features/home/widgets/prayer_times_widget.dart';
import 'package:azkar/src/features/home/widgets/qiblah_compass.dart';
import 'package:azkar/src/features/settings/settings_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final img = Image.asset(
      AppImages.logoText,
      height: size.height * .20,
      fit: BoxFit.cover,
    );
    return SingleChildScrollView(
      physics: const ScrollPhysics(parent: ClampingScrollPhysics()),
      child: Column(
        children: [
          // (size.height * (Platform.isAndroid ? .04 : .06)).ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: precacheImage(img.image, context),
                  builder: (context, snapshot) {
                    return EntranceFader(
                        duration: const Duration(milliseconds: 200),
                        offset: const Offset(0.0, 0.0),
                        child: img);
                  }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => showAdaptiveDialog(
                        context: context,
                        builder: (context) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 90.ph,
                            const QiblahCompass(),
                            Material(
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.close,
                                    size: 50, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Material(
                          shape: const CircleBorder(),
                          color: theme.primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.navigation_sharp,
                              color: whiteColor,
                              size: 30,
                            ),
                          )),
                    ),
                    15.pw,
                    InkWell(
                      onTap: () =>
                          NV.nextScreenNamed(context, SettingsView.routeName),
                      child: Material(
                          shape: const CircleBorder(),
                          color: theme.primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.settings,
                              color: whiteColor,
                              size: 30,
                            ),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
          const PrayersTimesWidget(),
          const DouaaCard(),
          // const ImsakiaButton(),
          const NamesSection(),
          ((MediaQuery.viewPaddingOf(context).bottom * 2) + kToolbarHeight).ph,

        20.ph
        ],
      ),
    );
  }
}
