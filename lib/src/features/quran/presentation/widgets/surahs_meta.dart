import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/utils/extentions.dart';
import '../../../../core/utils/app_images.dart';
import '../../domain/entities/surahs.dart';
import '../pages/surah_screen.dart';
import 'package:flutter/material.dart';

class SurahsMeta extends StatelessWidget {
  final ReferencesEntity reference;
  final bool pinned;
  const SurahsMeta({super.key, required this.reference, this.pinned = false});

  @override
  Widget build(BuildContext context) {
    // final dSize = MediaQuery.of(context).size;
    String rType(String type) {
      return type == "Meccan" ? 'مكية' : "مدنية";
    }

    final theme = Theme.of(context);
    return EntranceFader(
      delay: const Duration(milliseconds: 250),
      duration: const Duration(milliseconds: 350),
      offset: const Offset(0.0, 50.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SurahScreen(ref: reference),
        )),
        child: Card(
          // margin: EdgeInsets.zero,
          // shape: RoundedRectangleBorder(),
          color: pinned ? theme.colorScheme.secondary : theme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      AppImages.numAya,
                      width: 60,
                      height: 60,
                      color: pinned ? theme.primaryColor : whiteColor,
                    ),
                    Text(reference.number.toString(),
                        style: theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w900,
                            color: pinned ? theme.primaryColor : whiteColor)),
                  ],
                ),
                10.pw,
                Expanded(
                  child: Text(reference.name!,
                      style: theme.textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: pinned ? theme.primaryColor : whiteColor,
                          fontFamily: 'HafsSmart')),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      reference.englishName!,
                      style: TextStyle(
                        color: pinned ? theme.primaryColor : whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    10.ph,
                    Text(
                        '${rType(reference.revelationType!)} - ${reference.numberOfAyahs} آية',
                        style: TextStyle(
                          color: pinned ? theme.primaryColor : whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
