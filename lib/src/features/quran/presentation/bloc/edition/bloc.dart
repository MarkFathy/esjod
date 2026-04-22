import 'dart:async';

import '../../../domain/entities/surah.dart';
import '../../../domain/use_cases/get_editions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/error_cases.dart';
import '../../../../../core/error/failures.dart';
part 'event.dart';
part 'state.dart';

class EditionBloc extends Bloc<EditionEvent, EditionState> {
  final GetEditionsUC getEditionsUC;
  EditionBloc({
    required this.getEditionsUC,
  }) : super(EditionInitialState()) {
    on<GetEditionEvent>(_getEdition);
  }
  FutureOr<void> _getEdition(
      GetEditionEvent event, Emitter<EditionState> emit) async {
    emit(EditionLoadingState());
    final failureOrSections = await getEditionsUC();
    emit(_mapFailureOrSectionsToState(failureOrSections));
  }

  EditionState _mapFailureOrSectionsToState(
      Either<Failure, List<EditionEntity>> failureOrSections) {
    return failureOrSections.fold(
        (failure) => EditionErrorState(message: mapFailureToMessage(failure)),
        (edition) => EditionLoadedState(edition: edition));
  }
}
