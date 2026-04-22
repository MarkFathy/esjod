class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class CurrentLocationException implements Exception {}

class FingerPrintAuthException implements Exception {}
