import 'package:azkar/src/core/utils/extentions.dart';
import '../../domain/entities/surah.dart';
import '../bloc/edition/bloc.dart';
import '../bloc/surah/bloc.dart';
import '../../../../injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditionsList extends StatefulWidget {
  final int number;
  const EditionsList({super.key, required this.number});

  @override
  State<EditionsList> createState() => _EditionsListState();
}

class _EditionsListState extends State<EditionsList> {
  EditionEntity? textEdition;
  EditionEntity? audioEdition;
  void onChange() => context.read<SurahBloc>().add(GetSurahEvent(
      number: widget.number,
      audioEdition:
          audioEdition == null ? 'quran-uthmani' : audioEdition!.identifier!,
      translationEdition:
          textEdition == null ? 'ar.alafasy' : textEdition!.identifier!));
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<EditionBloc>(
      create: (context) {
        return sl<EditionBloc>()..add(const GetEditionEvent());
      },
      child: BlocBuilder<EditionBloc, EditionState>(
        builder: (context, state) {
          if (state is EditionLoadedState) {
            textEdition ??= state.edition
                .firstWhere((element) => element.identifier == 'quran-uthmani');
            audioEdition ??= state.edition
                .firstWhere((element) => element.identifier == 'ar.alafasy');
          }
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: DropdownButton<EditionEntity>(
                        icon: const Icon(Icons.language),
                        value: textEdition,
                        alignment: Alignment.center,
                        elevation: 5,
                        underline: const Center(),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        isExpanded: true,
                        hint: const Text(
                          "اللغة",
                        ),
                        items: state is EditionLoadedState
                            ? state.edition
                                .where((element) {
                                  return element.format == "text";
                                })
                                .map((edition) =>
                                    DropdownMenuItem<EditionEntity>(
                                      value: edition,
                                      child: Text(
                                          "${edition.name} | ${edition.language!.toUpperCase()}",
                                          style: theme.textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis),
                                    ))
                                .toList()
                            : <DropdownMenuItem<EditionEntity>>[],
                        onChanged: (value) {
                          setState(() {
                            textEdition = value;
                          });
                          onChange();
                        }),
                  ),
                ),
                // const SizedBox(height: 20),
                5.pw,
                Expanded(
                  flex: 1,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: DropdownButton<EditionEntity>(
                        icon: const Icon(Icons.audiotrack_outlined),
                        value: audioEdition,
                        isExpanded: true,
                        underline: const Center(),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        hint: const Text(
                          "الصوت",
                        ),
                        items: state is EditionLoadedState
                            ? state.edition
                                .where((element) {
                                  return element.format == "audio";
                                })
                                .map((edition) =>
                                    DropdownMenuItem<EditionEntity>(
                                        value: edition,
                                        child: Text(
                                          "${edition.name} | ${edition.language!.toUpperCase()}",
                                          maxLines: 1,
                                          style: theme.textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        )))
                                .toList()
                            : <DropdownMenuItem<EditionEntity>>[],
                        onChanged: (value) {
                          setState(() {
                            audioEdition = value;
                          });
                          onChange();
                        }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
