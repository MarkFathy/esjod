part of 'bloc.dart';

abstract class NamesEvent extends Equatable {
  const NamesEvent();
}

class LoadNames extends NamesEvent {
  const LoadNames();

  @override
  List<Object?> get props => [];
}