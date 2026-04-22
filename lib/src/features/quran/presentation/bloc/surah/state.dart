part of 'bloc.dart';

abstract class SurahState extends Equatable {
  const SurahState();

  @override
  List<Object> get props => [];
}

class SurahInitialState extends SurahState {}

class SurahLoadingState extends SurahState {}

class SurahOfflineLoadedState extends SurahState {
  final List<Map<dynamic, dynamic>> surah;

  const SurahOfflineLoadedState({required this.surah});

  @override
  List<Object> get props => [surah];
}

class SurahLoadedState extends SurahState {
  final SurahEntity surah;

  const SurahLoadedState({required this.surah});

  @override
  List<Object> get props => [surah];
}

class SurahErrorState extends SurahState {
  final String message;

  const SurahErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
