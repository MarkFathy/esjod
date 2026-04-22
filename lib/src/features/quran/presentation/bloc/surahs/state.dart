part of 'bloc.dart';

abstract class SurahsState extends Equatable {
  const SurahsState();

  @override
  List<Object> get props => [];
}

class SurahsInitialState extends SurahsState {}

class SurahsLoadingState extends SurahsState {}

class SurahsLoadedState extends SurahsState {
  final SurahsEntity surahs;

  const SurahsLoadedState({required this.surahs});

  @override
  List<Object> get props => [surahs];
}

class SurahsErrorState extends SurahsState {
  final String message;

  const SurahsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
