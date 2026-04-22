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

class Quran extends StatelessWidget {
  const Quran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String query = "";
    final theme = Theme.of(context);
    return BlocProvider<SurahsBloc>(
      create: (context) => sl<SurahsBloc>()..add(GetSurahsEvent()),
      child: BlocBuilder<SurahsBloc, SurahsState>(
        builder: (context, surahState) {
          return BlocProvider<PinBloc>(
            create: (context) => sl<PinBloc>()..add(GetPinEvent()),
            child: BlocBuilder<PinBloc, PinState>(
              builder: (context, pinState) {
                return StatefulBuilder(builder: (context, setState) {
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
                                query = value;
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
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SurahScreen(
                                    ref: surahState.surahs.references!
                                        .firstWhere((element) =>
                                            pinState.pin!.surah! ==
                                            element.number),
                                  ),
                                ));
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
                              padding: EdgeInsets.zero,
                              children: surahState.surahs.references!
                                  .where((element) =>
                                      element.name!.startsWith(query) ||
                                      element.englishName!.startsWith(query))
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
                });
              },
            ),
          );
        },
      ),
    );
  }
}
