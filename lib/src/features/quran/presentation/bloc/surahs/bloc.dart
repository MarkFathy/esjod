import 'dart:async';

import '../../../domain/use_cases/get_surahs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/error_cases.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/surahs.dart';
part 'event.dart';

part 'state.dart';

class SurahsBloc extends Bloc<SurahsEvent, SurahsState> {
  final GetSurahsUC getSurahsUseCase;
  SurahsBloc({
    required this.getSurahsUseCase,
  }) : super(SurahsInitialState()) {
    on<GetSurahsEvent>(_getSurahs);
  }
  FutureOr<void> _getSurahs(
      GetSurahsEvent event, Emitter<SurahsState> emit) async {
    emit(SurahsLoadingState());
    final failureOrSections = await getSurahsUseCase();
    emit(_mapFailureOrSectionsToState(failureOrSections));
  }

  SurahsState _mapFailureOrSectionsToState(
      Either<Failure, SurahsEntity> failureOrSections) {
    return failureOrSections.fold(
        (failure) => SurahsErrorState(message: mapFailureToMessage(failure)),
        (surahs) => SurahsLoadedState(surahs: surahs));
  }
}
