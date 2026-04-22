import '../entities/surahs.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/quran_repository.dart';

class GetSurahsUC {
  final QuranRepository repository;

  GetSurahsUC(this.repository);

  Future<Either<Failure, SurahsEntity>> call() async {
    return await repository.getSurahs();
  }
}
