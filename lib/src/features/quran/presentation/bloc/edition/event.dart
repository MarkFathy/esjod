part of 'bloc.dart';

abstract class EditionEvent extends Equatable {
  const EditionEvent();

  @override
  List<Object> get props => [];
}

class GetEditionEvent extends EditionEvent {
  const GetEditionEvent();
  @override
  List<Object> get props => [];
}
