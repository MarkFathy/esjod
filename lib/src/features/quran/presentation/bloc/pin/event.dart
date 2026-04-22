part of 'bloc.dart';

abstract class PinEvent extends Equatable {
  const PinEvent();
  @override
  List<Object?> get props => [];
}

class GetPinEvent extends PinEvent {
  @override
  List<Object?> get props => [];
}

class SetPinEvent extends PinEvent {
  final PinModel pin;

  const SetPinEvent(this.pin);
  @override
  List<Object?> get props => [];
}
