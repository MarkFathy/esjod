import 'features/quran/domain/use_cases/get_editions.dart';
import 'features/quran/domain/use_cases/get_pin.dart';
import 'features/quran/domain/use_cases/get_surah.dart';
import 'features/quran/domain/use_cases/get_surahs.dart';
import 'features/quran/domain/use_cases/set_pin.dart';
import 'features/quran/presentation/bloc/edition/bloc.dart';
import 'features/quran/presentation/bloc/pin/bloc.dart';
import 'features/quran/presentation/bloc/surah/bloc.dart';
import 'features/quran/presentation/bloc/surahs/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/core/network/network_info.dart';
import 'features/quran/data/data_sources/quran_remote_data_source.dart';
import 'features/quran/data/repositories/quran_repository_impl.dart';
import 'features/quran/domain/repositories/quran_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  final sh = await SharedPreferences.getInstance();
  sl.registerFactory(() => sh);
  //Blocs
  sl.registerFactory(() => SurahsBloc(getSurahsUseCase: sl()));
  sl.registerFactory(() => SurahBloc(getSurahUseCase: sl()));
  sl.registerFactory(() => EditionBloc(getEditionsUC: sl()));
  sl.registerFactory(() => PinBloc(getPinUC: sl(), setPinUC: sl()));

  //Repository
  sl.registerLazySingleton<QuranRepository>(
      () => QuranRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  //Data sources
  sl.registerLazySingleton<QuranDataSource>(
      () => QuranDataSourceImpl(client: sl()));

  //Use cases
  sl.registerLazySingleton(() => GetSurahUC(sl()));
  sl.registerLazySingleton(() => GetSurahsUC(sl()));
  sl.registerLazySingleton(() => GetEditionsUC(sl()));
  sl.registerLazySingleton(() => GetPinUC(sl()));
  sl.registerLazySingleton(() => SetPinUC(sl()));
}
