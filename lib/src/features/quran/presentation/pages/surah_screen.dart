import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:azkar/src/core/utils/extentions.dart';
import 'package:azkar/src/features/quran/data/models/pin_model.dart';
import 'package:azkar/src/features/quran/presentation/widgets/audio_player.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../data/models/surah_model.dart';
import '../../domain/entities/surahs.dart';
import '../bloc/pin/bloc.dart';
import '../bloc/surah/bloc.dart';
import 'editions_list.dart';
import '../widgets/ayah_player.dart';
import '../../../../injection_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String defaultTranslationEdition = "quran-uthmani";
String defaultAudioEdition = "ar.alafasy";

class SurahScreen extends StatefulWidget {
  final ReferencesEntity ref;

  const SurahScreen({super.key, required this.ref});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  AudioPlayer? surahPlayer;
  Ayahs? selectedAyah;
  int? fontSize;
  bool isPlayerReady = false;
  bool isAudioInitialized = false;
  // int page = 1;
  @override
  void initState() {
    super.initState();
    surahPlayer = AudioP.player;
  }

  String rType(String type) {
    return type == "Meccan" ? 'مكية' : "مدنية";
  }

  @override
  void dispose() {
    surahPlayer?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl<SurahBloc>()
        ..add((GetSurahEvent(
            number: widget.ref.number!,
            audioEdition: defaultAudioEdition,
            translationEdition: defaultTranslationEdition))),
      child: BlocConsumer<SurahBloc, SurahState>(
         listener: (context, state) async {
  if (state is SurahLoadedState && !isAudioInitialized) {
    isAudioInitialized = true;
    final player = surahPlayer;
    if (player == null) return;

    try {
      await player.stop();
      await player.seek(Duration.zero); // ✅ reset position too
      await Future.delayed(const Duration(milliseconds: 100));

      await player.setAudioSource(
        ConcatenatingAudioSource(
          children: state.surah.audioData!.ayahs!
              .map((e) => AudioSource.uri(
                    Uri.parse(e.audio!),
                    tag: MediaItem(
                      id: e.number.toString(),
                      title: e.text ?? 'Ayah',
                    ),
                  ))
              .toList(),
        ),
      );

      setState(() => isPlayerReady = true);
    } catch (e) {
      debugPrint("Init error: $e");
      isAudioInitialized = false; // allow retry on error
    }
  }
}, builder: (context, surahState) {
        return StatefulBuilder(builder: (context, changeState) {
          return Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(dSize.height * .09),
                  child: Column(
                    children: [
                      EditionsList(
                        number: widget.ref.number!,
                      ),
                      Material(
                        color: theme.colorScheme.secondary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if ((surahState is SurahLoadedState)) ...[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'الجزء ${surahState.surah.mainData!.ayahs!.first.juz}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'الصفحات ${surahState.surah.mainData!.ayahs!.first.page}-${surahState.surah.mainData!.ayahs!.last.page}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'الحزب ${surahState.surah.mainData!.ayahs!.first.hizbQuarter}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              )
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      isExpanded: false,
                      icon: const Center(),
                      value: fontSize,
                      underline: const Center(),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      dropdownColor: theme.primaryColor,
                      menuMaxHeight: dSize.height * .6,
                      hint: Text(
                        'حجم الخط',
                        style: theme.textTheme.titleMedium!
                            .copyWith(color: whiteColor),
                      ),
                      items: List.generate(
                          26,
                          (index) => DropdownMenuItem(
                              value: index + 25,
                              child: Text(
                                (index + 25).toString(),
                                style: theme.textTheme.titleLarge!
                                    .copyWith(color: whiteColor),
                              ))),
                      onChanged: (value) =>
                          changeState(() => fontSize = value!),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                      child: BlocProvider<PinBloc>(
                          create: (context) =>
                              sl<PinBloc>()..add(GetPinEvent()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Header(
                                name: widget.ref.name!,
                              ),
                              5.ph,

                              ///
                              if (surahState is SurahLoadingState)
                                const AppIndicator(),
                              ////
                              if (surahState is SurahOfflineLoadedState)
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: BlocBuilder<PinBloc, PinState>(
                                          builder: (context, pinState) {
                                        return RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(
                                                children: surahState.surah
                                                    .map((ayah) => TextSpan(
                                                          text:
                                                              "${ayah['text']!} (${ayah['verse']!.toString()}) ",
                                                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  (fontSize ?? 25)
                                                                      .toDouble(),
                                                              fontFamily:
                                                                  'HafsSmart',
                                                              backgroundColor: (pinState is PinLoadedState &&
                                                                      pinState.pin !=
                                                                          null &&
                                                                      pinState.pin!
                                                                              .ayah ==
                                                                          ayah[
                                                                              'verse'] &&
                                                                      pinState.pin!
                                                                              .surah ==
                                                                          widget
                                                                              .ref
                                                                              .number)
                                                                  ? theme
                                                                      .colorScheme
                                                                      .secondary
                                                                  : null,
                                                              height: 2.2),
                                                          recognizer:
                                                              TapGestureRecognizer(
                                                                  debugOwner: ayah[
                                                                      'verse'])
                                                                ..onTap =
                                                                    () async {
                                                                  if (pinState
                                                                      is PinLoadedState) {
                                                                    if (pinState.pin !=
                                                                            null &&
                                                                        pinState.pin!.ayah ==
                                                                            ayah[
                                                                                'verse'] &&
                                                                        widget.ref.number ==
                                                                            pinState.pin!.surah) {
                                                                      context
                                                                          .read<
                                                                              PinBloc>()
                                                                          .add(const SetPinEvent(
                                                                              PinModel()));
                                                                    } else {
                                                                      context.read<PinBloc>().add(SetPinEvent(PinModel(
                                                                          ayah: ayah[
                                                                              'verse'],
                                                                          surah: widget
                                                                              .ref
                                                                              .number,
                                                                          title: widget
                                                                              .ref
                                                                              .name)));
                                                                    }
                                                                  }
                                                                },
                                                        ))
                                                    .toList()));
                                      })),
                                )),

                              ///
                              if (surahState is SurahLoadedState)
                                Expanded(
                                    child: Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: StreamBuilder<PlayerState>(
                                              stream: surahPlayer!
                                                  .playerStateStream,
                                              builder:
                                                  (context, playerStateSnap) {
                                                return StreamBuilder<
                                                        SequenceState?>(
                                                    stream: surahPlayer!
                                                        .sequenceStateStream,
                                                    builder: (context,
                                                        sequenceSnap) {
                                                      final currentSeq =
                                                          sequenceSnap.data;
                                                      final isBuffering =
                                                          playerStateSnap.data
                                                                  ?.processingState ==
                                                              ProcessingState
                                                                  .buffering;
                                                      final isPlaying =
                                                          playerStateSnap.data
                                                                  ?.playing ??
                                                              false;

                                                      return BlocBuilder<
                                                              PinBloc,
                                                              PinState>(
                                                          builder: (context,
                                                              pinState) {
                                                        return RichText(
                                                            textAlign: TextAlign
                                                                .justify,
                                                            text: TextSpan(
                                                                children: surahState
                                                                    .surah
                                                                    .translationData!
                                                                    .ayahs!
                                                                    .map((ayah) =>
                                                                        TextSpan(
                                                                          text:
                                                                              "${ayah.text!} (${ayah.numberInSurah!.toString()}) ",
                                                                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                                              fontWeight: FontWeight.normal,
                                                                              backgroundColor: surahPlayer != null && isPlaying && currentSeq != null && ayah.number.toString() == (currentSeq.currentSource?.tag as MediaItem?)?.id
                                                                                  ? Colors.lightGreen.withOpacity(.5)
                                                                                  : (pinState is PinLoadedState && pinState.pin != null && pinState.pin!.ayah == ayah.numberInSurah && pinState.pin!.surah == widget.ref.number)
                                                                                      ? theme.colorScheme.secondary
                                                                                      : null,
                                                                              fontFamily: 'HafsSmart',
                                                                              fontSize: (fontSize ?? 25).toDouble(),
                                                                              height: 2.2),
                                                                          recognizer: TapGestureRecognizer(
                                                                              debugOwner: surahState.surah.mainData!.number)
                                                                            ..onTap = () async {
                                                                              selectedAyah = ayah;

                                                                              final player = surahPlayer;

                                                                              if (player == null)
                                                                                return;

                                                                              final state = player.playerState;

                                                                              // ❌ لو لسه بيعمل loading
                                                                              if (state.processingState == ProcessingState.loading || state.processingState == ProcessingState.buffering) {
                                                                                return;
                                                                              }

                                                                              // ❌ لو مش جاهز
                                                                              if (!isPlayerReady)
                                                                                return;

                                                                              try {
                                                                                await player.seek(
                                                                                  Duration.zero,
                                                                                  index: ayah.numberInSurah! - 1,
                                                                                );

                                                                                if (!player.playing) {
                                                                                  await player.play();
                                                                                }
                                                                              } catch (e) {
                                                                                debugPrint("Play error: $e");
                                                                              }
                                                                            },
                                                                        ))
                                                                    .toList()));
                                                      });
                                                    });
                                              }),
                                        ),
                                      ),
                                    ),
                                    BlocBuilder<PinBloc, PinState>(
                                        builder: (context, pinState) {
                                      return AyahPlayer(
                                        pinning: () async {
                                          if (selectedAyah == null) {
                                            return;
                                          }
                                          if (pinState is PinLoadedState) {
                                            if (pinState.pin != null &&
                                                pinState.pin!.ayah ==
                                                    selectedAyah!
                                                        .numberInSurah &&
                                                widget.ref.number ==
                                                    pinState.pin!.surah) {
                                              context.read<PinBloc>().add(
                                                  const SetPinEvent(
                                                      PinModel()));
                                            } else {
                                              context.read<PinBloc>().add(
                                                  SetPinEvent(PinModel(
                                                      ayah: selectedAyah!
                                                          .numberInSurah,
                                                      surah: widget.ref.number,
                                                      title: widget.ref.name)));
                                            }
                                          }
                                        },
                                        audioPlayer: surahPlayer!,
                                      );
                                    })
                                  ],
                                ))
                            ],
                          ))),
                ],
              ));
        });
      }),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(), top: BorderSide())),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/title-r.png",
            height: dSize.height * 0.05,
            color: theme.colorScheme.primary,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  name,
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontFamily: "HafsSmart"),
                ),
              ),
            ),
          ),
          Image.asset(
            "assets/images/title-l.png",
            height: dSize.height * 0.05,
            color: theme.colorScheme.primary,
          )
        ],
      ),
    );
  }
}
