import 'package:azkar/main.dart';
import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:azkar/src/core/utils/extentions.dart';
import 'package:azkar/src/features/home/widgets/prayer_remain_time.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayersTimesWidget extends StatelessWidget {
  const PrayersTimesWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Future<String> getAddress(double lat, lng) async {
    //   var addresses = await geod.Geocoder.local
    //       .findAddressesFromCoordinates(geod.Coordinates(lat, lng))
    //       .catchError((error) {
    //     debugPrint(error);
    //     throw error;
    //   });
    //   var first = addresses.first;
    //   return ("${first.locality}");
    // }

    HijriCalendar.setLocal('ar');
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: FutureBuilder(
          future: prayerService.initialPrayerTimes(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Material(
                                color: primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      HijriCalendar.now().fullDate(),
                                      style: theme.textTheme.titleMedium!.copyWith(
                                          color: whiteColor,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                )),
                            10.ph,
                            Material(
                              color: primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    DateFormat.yMMMMd('ar_SA')
                                        .format(DateTime.now()),
                                    style: theme.textTheme.titleMedium!.copyWith(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (prayerService.prayerTimes != null ||
                              snapshot.connectionState == ConnectionState.done)
                          ? PrayerRemainTime(
                              prayTime: prayerService.nextPrayerTime ??
                                  DateTime.now(),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(.4, 1.7),
                                        blurRadius: 1.5,
                                        spreadRadius: .4)
                                  ]),
                              width: size.width * .4,
                              height: size.width * .4,
                              child: const CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                    ],
                  ),
                ),
                10.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: PrayTimeCard(
                          loading:
                              snapshot.connectionState == ConnectionState.waiting,
                          image: AppImages.timeSalah1,
                          title: 'الفجر',
                          time: prayerService.prayerTimes?.fajr,
                          next: prayerService.prayerTimes?.nextPrayer().name ==
                              'fajr',
                          icon: Image.asset(
                            AppImages.timeSalah1,
                            height: 60,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: PrayTimeCard(
                          loading:
                              snapshot.connectionState == ConnectionState.waiting,
                          image: AppImages.timeSalah2,
                          title: 'الظهر',
                          icon: Image.asset(
                            AppImages.timeSalah2,
                            height: 60,
                          ),
                          time: prayerService.prayerTimes?.dhuhr,
                          next: prayerService.prayerTimes?.nextPrayer().name ==
                              'dhuhr',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: PrayTimeCard(
                          loading:
                              snapshot.connectionState == ConnectionState.waiting,
                          image: AppImages.timeSalah3,
                          title: 'العصر',
                          icon: Image.asset(
                            AppImages.timeSalah3,
                            height: 60,
                          ),
                          time: prayerService.prayerTimes?.asr,
                          next:
                              prayerService.prayerTimes?.nextPrayer().name == 'asr',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: PrayTimeCard(
                          loading:
                              snapshot.connectionState == ConnectionState.waiting,
                          image: AppImages.timeSalah4,
                          title: 'المغرب',
                          icon: Image.asset(
                            AppImages.timeSalah4,
                            height: 60,
                          ),
                          time: prayerService.prayerTimes?.maghrib,
                          next: prayerService.prayerTimes?.nextPrayer().name ==
                              'maghrib',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: PrayTimeCard(
                          loading:
                              snapshot.connectionState == ConnectionState.waiting,
                          image: AppImages.timeSalah5,
                          title: 'العشاء',
                          icon: Image.asset(
                            AppImages.timeSalah5,
                            height: 60,
                          ),
                          time: prayerService.prayerTimes?.isha,
                          next:
                              prayerService.prayerTimes?.nextPrayer().name == 'isha',
                        ),
                      ),
                    ),
                  ],
                ),
              
              ],
            );
          }),
    );
  }
}

class PrayTimeCard extends StatelessWidget {
  const PrayTimeCard(
      {super.key,
      required this.image,
      required this.title,
      required this.icon,
      this.time,
      this.loading = true,
      this.next = false});

  final String image, title;
  final DateTime? time;
  final bool next;
  final bool loading;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8),
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if (next) PrayerRemainTime(prayTime: time!),
            icon,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColor,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                loading
                    ? '--:--'
                    : (time != null
                        ? DateFormat.jm('ar').format(time!.toLocal())
                        : '00:00'),
                style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w900, color: theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
