import 'failures.dart';

String mapFailureToMessage(Failure failure, [String? message]) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return "Server Failure";
    default:
      return "Failure";
  }
}
