import '../models/pin_model.dart';
import '../models/surah_model.dart';
import '../../domain/entities/pin.dart';
import '../../domain/entities/surah.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/surahs.dart';
import '../../domain/repositories/quran_repository.dart';
import '../data_sources/quran_remote_data_source.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  QuranRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, SurahsEntity>> getSurahs() async {
    try {
      final remoteSections = await remoteDataSource.fetchSurahs();
      return Right(remoteSections);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Edition>>> getEditions() async {
    try {
      final remoteSections = await remoteDataSource.fetchEditions();
      return Right(remoteSections);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SurahEntity>> getSurah(
      {required int number,
      required String audioEdition,
      required String translationEdition}) async {
    try {
      final remoteSections = await remoteDataSource.fetchSurah(
          number: number,
          audioEdition: audioEdition,
          translationEdition: translationEdition);
      return Right(remoteSections);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PinEntity?>> getPin() async {
    try {
      final remoteSections = await remoteDataSource.getPin();
      return Right(remoteSections);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PinEntity>> setPin(PinModel entity) async {
    try {
      final remoteSections = await remoteDataSource.setPin(entity);
      return Right(remoteSections!);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
