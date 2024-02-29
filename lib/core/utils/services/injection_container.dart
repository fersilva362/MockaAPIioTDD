import 'package:get_it/get_it.dart';
import 'package:tdd_clean_architecture/src/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_clean_architecture/src/data/repositories/authentication_repostitories_implementation.dart';
import 'package:tdd_clean_architecture/src/domain/repositories/authtentication_repository.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/create_user.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/get_users.dart';
import 'package:tdd_clean_architecture/src/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerFactory<AuthenticationCubit>(
        () => AuthenticationCubit(sl(), sl()))
    ..registerLazySingleton(
      () => CreateUser(sl()),
    )
    ..registerLazySingleton(() => GetUser(sl()))
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepoImplemtation(sl()))
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthRemoteDataimpl(sl()),
    )
    ..registerLazySingleton(
      () => http.Client(),
    );
}
