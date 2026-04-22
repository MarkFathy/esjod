part of 'bloc.dart';

abstract class EditionState extends Equatable {
  const EditionState();

  @override
  List<Object> get props => [];
}

class EditionInitialState extends EditionState {}

class EditionLoadingState extends EditionState {}

class EditionLoadedState extends EditionState {
  final List<EditionEntity> edition;

  const EditionLoadedState({required this.edition});

  @override
  List<Object> get props => [edition];
}

class EditionErrorState extends EditionState {
  final String message;

  const EditionErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
