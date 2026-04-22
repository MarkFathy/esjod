import '../entities/surah.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/quran_repository.dart';

class GetSurahUC {
  final QuranRepository repository;

  GetSurahUC(this.repository);

  Future<Either<Failure, SurahEntity>> call(
      {required int number,
      required String audioEdition,
      required String translationEdition}) async {
    return await repository.getSurah(
        number: number,
        audioEdition: audioEdition,
        translationEdition: translationEdition);
  }
}
