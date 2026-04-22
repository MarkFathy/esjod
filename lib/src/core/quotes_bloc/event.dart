part of 'bloc.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();
}

class LoadQuotes extends QuotesEvent {
  const LoadQuotes();

  @override
  List<Object?> get props => [];
}