part of 'bloc.dart';

abstract class NamesState extends Equatable {
  const NamesState();
}

class NamesInitial extends NamesState {
  @override
  List<Object> get props => [];
}

class NamesLoading extends NamesState {
  @override
  List<Object> get props => [];
}

class NamesLoadSuccess extends NamesState {
  final List<NameModel> names;

  const NamesLoadSuccess(this.names);

  @override
  List<Object> get props => [names];
}

class NamesLoadFailed extends NamesState {
  final Exception exception;

  const NamesLoadFailed(this.exception);

  @override
  List<Object> get props => [exception];
}