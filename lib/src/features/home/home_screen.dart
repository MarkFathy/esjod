import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:azkar/src/features/home/widgets/home_body.dart';
import 'package:azkar/src/features/quran/presentation/pages/quran.dart';
import '../../core/utils/app_images.dart';
import 'widgets/quotes_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Image img = Image.asset(AppImages.backGround,
        fit: BoxFit.cover, alignment: Alignment.centerRight);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
              future: precacheImage(img.image, context),
              builder: (context, snapshot) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    img,
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.viewPaddingOf(context).top),
                      child: const TabBarView(
                        children: [
                          HomeBody(),
                          QuotesSection(),
                          Quran(),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.viewPaddingOf(context).bottom,
                      left: 5,
                      right: 5,
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.hardEdge,
                        elevation: 4,
                        child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                color: theme.colorScheme.secondary
                                    .withOpacity(.2)),
                            labelStyle: theme.textTheme.labelMedium!
                                .copyWith(color: primaryColor),
                            unselectedLabelStyle: theme.textTheme.labelMedium!
                                .copyWith(color: theme.primaryColor),
                            labelPadding: EdgeInsets.zero,
                            automaticIndicatorColorAdjustment: true,
                            padding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                icon: Image.asset(
                                  AppImages.navHome,
                                  color: theme.primaryColor,
                                ),
                                child: Text(
                                  'الرئيسية',
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w900),
                                ),
                              ),
                              Tab(
                                icon: Image.asset(
                                  AppImages.navMore,
                                  color: theme.primaryColor,
                                ),
                                child: Text(
                                  'الأذكار',
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w900),
                                ),
                              ),
                              Tab(
                                icon: Image.asset(
                                  AppImages.navQuran,
                                  color: theme.primaryColor,
                                ),
                                child: Text(
                                  'القرآن الكريم',
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
