import 'dart:async';

import '../../../data/models/pin_model.dart';
import '../../../domain/entities/pin.dart';
import '../../../domain/use_cases/get_pin.dart';
import '../../../domain/use_cases/set_pin.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/error_cases.dart';
import '../../../../../core/error/failures.dart';
part 'event.dart';
part 'state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  final GetPinUC getPinUC;
  final SetPinUC setPinUC;
  PinBloc({required this.setPinUC, required this.getPinUC})
      : super(PinInitialState()) {
    on<GetPinEvent>(_getPin);
    on<SetPinEvent>(_setPin);
  }
  FutureOr<void> _getPin(GetPinEvent event, Emitter<PinState> emit) async {
    emit(PinLoadingState());
    final failureOrSections = await getPinUC();
    emit(_mapFailureOrPinToState(failureOrSections));
  }

  FutureOr<void> _setPin(SetPinEvent event, Emitter<PinState> emit) async {
    emit(PinLoadingState());
    final failureOrSections = await setPinUC(event.pin);
    emit(_mapFailureOrPinToState(failureOrSections));
  }

  PinState _mapFailureOrPinToState(
      Either<Failure, PinEntity?> failureOrSections) {
    return failureOrSections.fold((failure) {
      return PinErrorState(message: mapFailureToMessage(failure));
    }, (pin) {
      return PinLoadedState(pin: pin);
    });
  }
}
