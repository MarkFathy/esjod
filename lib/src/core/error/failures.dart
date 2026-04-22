import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class OfflineFailure extends Failure {}

class ServerFailure extends Failure {}

class FingerPrintAuthFailure extends Failure {}

class EmptyCacheFailure extends Failure {}

class CurrentLocationFailure extends Failure {
  final String error;

  CurrentLocationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
