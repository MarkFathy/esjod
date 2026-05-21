import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:azkar/src/features/home/widgets/page_title.dart';
import 'package:azkar/src/features/quran/presentation/pages/surah_screen.dart';
import '../../../../core/widgets/app_loader.dart';
import '../bloc/pin/bloc.dart';
import '../bloc/surahs/bloc.dart';
import '../widgets/surahs_meta.dart';
import '../../../../injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Quran extends StatefulWidget {
  const Quran({Key? key}) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  String _query = "";

  String _normalizeArabic(String text) {
    // Remove diacritics (tashkeel and Quranic marks)
    final diacritics = RegExp(r'[\u0610-\u061A\u064B-\u065F\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]');
    String normalized = text.replaceAll(diacritics, '');

    // Normalize Alef variations
    normalized = normalized.replaceAll(RegExp(r'[أإآٱ]'), 'ا');

    // Normalize Taa Marbutah / Haa
    normalized = normalized.replaceAll('ة', 'ه');

    // Normalize Yaa / Alef Maksura
    normalized = normalized.replaceAll('ى', 'ي');

    return normalized.trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<SurahsBloc>(
      create: (context) => sl<SurahsBloc>()..add(GetSurahsEvent()),
      child: BlocBuilder<SurahsBloc, SurahsState>(
        builder: (context, surahState) {
          return BlocProvider<PinBloc>(
            create: (context) => sl<PinBloc>()..add(GetPinEvent()),
            child: BlocBuilder<PinBloc, PinState>(
              builder: (context, pinState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageTitle(title: 'القرآن الكريم'),
                      Container(
                        decoration: const BoxDecoration(
                            color: whiteColor,
                            border: Border(
                                bottom: BorderSide(color: whiteColor))),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            style: theme.textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                            onChanged: (value) => setState(() {
                              _query = value;
                            }),
                            decoration: InputDecoration(
                                hintText: "بحث",
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: theme.primaryColor,
                                )),
                          ),
                        ),
                      ),
                      const Divider(),
                      if (surahState is SurahsLoadingState)
                        const Center(child: AppIndicator()),
                      if (surahState is SurahsLoadedState) ...[
                        if (pinState is PinLoadedState &&
                            pinState.pin?.ayah != null)
                          InkWell(
                            onTap: () {
                              final pinBloc = context.read<PinBloc>();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SurahScreen(
                                  ref: surahState.surahs.references!
                                      .firstWhere((element) =>
                                          pinState.pin!.surah! ==
                                          element.number),
                                ),
                              )).then((_) {
                                pinBloc.add(GetPinEvent());
                              });
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              elevation: 5,
                              color: theme.colorScheme.secondary,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.bookmark,
                                      color: theme.primaryColor,
                                    ),
                                    Text(pinState.pin!.title ?? '',
                                        style: theme.textTheme.titleLarge!
                                            .copyWith(
                                                color: theme.primaryColor,
                                                fontFamily: '')),
                                    Text(
                                      'اية رقم ${pinState.pin!.ayah}',
                                      style:
                                          theme.textTheme.bodyLarge!.copyWith(
                                        color: theme.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 100),
                            children: surahState.surahs.references!
                                .where((element) {
                                  final q = _query.trim().toLowerCase();
                                  if (q.isEmpty) return true;

                                  final normalizedSurahName = _normalizeArabic(element.name ?? '');
                                  final normalizedQuery = _normalizeArabic(q);

                                  final englishName = element.englishName?.toLowerCase() ?? '';
                                  final englishNameTranslation = element.englishNameTranslation?.toLowerCase() ?? '';

                                  return normalizedSurahName.contains(normalizedQuery) ||
                                      englishName.contains(q) ||
                                      englishNameTranslation.contains(q);
                                })
                                .map((reference) => SurahsMeta(
                                      reference: reference,
                                      pinned: pinState is PinLoadedState &&
                                              pinState.pin != null
                                          ? pinState.pin!.surah ==
                                              reference.number
                                          : false,
                                    ))
                                .toList(),
                          ),
                        )
                      ]
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
