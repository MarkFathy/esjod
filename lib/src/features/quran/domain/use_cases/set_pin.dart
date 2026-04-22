import '../../data/models/pin_model.dart';
import '../entities/pin.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/quran_repository.dart';

class SetPinUC {
  final QuranRepository repository;

  SetPinUC(this.repository);

  Future<Either<Failure, PinEntity>> call(PinModel pin) async {
    return await repository.setPin(pin);
  }
}
