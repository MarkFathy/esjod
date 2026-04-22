part of 'bloc.dart';

abstract class PinState extends Equatable {
  const PinState();

  @override
  List<Object?> get props => [];
}

class PinInitialState extends PinState {}

class PinLoadingState extends PinState {}

class PinLoadedState extends PinState {
  final PinEntity? pin;
  const PinLoadedState({required this.pin});

  @override
  List<Object?> get props => [pin];
}

class PinErrorState extends PinState {
  final String message;

  const PinErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
