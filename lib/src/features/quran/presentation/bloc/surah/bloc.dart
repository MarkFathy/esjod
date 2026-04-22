import 'dart:async';
import 'dart:convert';
import 'package:azkar/src/core/error/failures.dart';
import 'package:flutter/services.dart';
import '../../../domain/entities/surah.dart';
import '../../../domain/use_cases/get_surah.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'event.dart';
part 'state.dart';

class SurahBloc extends Bloc<SurahEvent, SurahState> {
  final GetSurahUC getSurahUseCase;
  SurahBloc({
    required this.getSurahUseCase,
  }) : super(SurahInitialState()) {
    on<GetSurahEvent>(_getSurah);
  }

  FutureOr<void> _getSurah(
      GetSurahEvent event, Emitter<SurahState> emit) async {
    emit(SurahLoadingState());

    final failureOrSections = await getSurahUseCase(
        number: event.number,
        audioEdition: event.audioEdition,
        translationEdition: event.translationEdition);
    final value = failureOrSections.fold((failure) {
      return failure;
    }, (surah) {
      return surah;
    });
    if (value is Failure) {
      final souratData =
          await rootBundle.loadString("assets/json/quran.json", cache: true);
      emit(SurahOfflineLoadedState(
          surah: List.from(jsonDecode(souratData)[event.number.toString()])));
    } else if (value is SurahEntity) {
      emit(SurahLoadedState(surah: value));
    }
  }
}
