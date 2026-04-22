part of 'bloc.dart';

abstract class SurahEvent extends Equatable {
  const SurahEvent();
  @override
  List<Object?> get props => [];
}

class GetSurahEvent extends SurahEvent {
  final int number;
  final String audioEdition;
  final String translationEdition;
  const GetSurahEvent(
      {required this.number,
      required this.audioEdition,
      required this.translationEdition});
  @override
  List<Object?> get props => [number, audioEdition, translationEdition];
}

class GetOfflineSurahEvent extends SurahEvent {
  final int number;

  const GetOfflineSurahEvent({required this.number});
  @override
  List<Object?> get props => [number];
}
