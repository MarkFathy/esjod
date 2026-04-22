import '../../data/models/pin_model.dart';
import '../../data/models/surah_model.dart';
import '../entities/pin.dart';
import '../entities/surah.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/surahs.dart';

abstract class QuranRepository {
  Future<Either<Failure, SurahsEntity>> getSurahs();
  Future<Either<Failure, PinEntity?>> getPin();
  Future<Either<Failure, PinEntity>> setPin(PinModel entity);
  Future<Either<Failure, SurahEntity>> getSurah(
      {required int number,
      required String audioEdition,
      required String translationEdition});
  Future<Either<Failure, List<Edition>>> getEditions();
}
