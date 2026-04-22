part of 'bloc.dart';

abstract class QuotesState extends Equatable {
  const QuotesState();
}

class QuotesInitial extends QuotesState {
  @override
  List<Object> get props => [];
}

class QuotesLoading extends QuotesState {
  @override
  List<Object> get props => [];
}

class QuotesLoadSuccess extends QuotesState {
  final List<CategoryModel> quotes;

  const QuotesLoadSuccess(this.quotes);

  @override
  List<Object> get props => [quotes];
}

class QuotesLoadFailed extends QuotesState {
  final Exception exception;

  const QuotesLoadFailed(this.exception);

  @override
  List<Object> get props => [exception];
}