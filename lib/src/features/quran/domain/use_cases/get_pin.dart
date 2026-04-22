import '../entities/pin.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/quran_repository.dart';

class GetPinUC {
  final QuranRepository repository;

  GetPinUC(this.repository);

  Future<Either<Failure, PinEntity?>> call() async {
    return await repository.getPin();
  }
}
