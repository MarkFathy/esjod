import '../entities/surah.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/quran_repository.dart';

class GetEditionsUC {
  final QuranRepository repository;

  GetEditionsUC(this.repository);

  Future<Either<Failure, List<EditionEntity>>> call() async {
    return await repository.getEditions();
  }
}
